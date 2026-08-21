class AuditLog < ApplicationRecord
  # Arbitrary fixed key for a Postgres advisory lock that serializes chain
  # writes across concurrent transactions, so sequence_number/entry_hash
  # can never be computed from the same "last entry" twice.
  CHAIN_LOCK_KEY = 847_291_003

  belongs_to :user, optional: true

  validates :action, :auditable_type, :auditable_id, presence: true

  before_create :compute_hash

  def self.record!(action:, auditable:, changes: {})
    create!(
      user: Current.user,
      action: action,
      auditable_type: auditable.class.name,
      auditable_id: auditable.id,
      changes_data: changes
    )
  end

  def self.verify_chain!
    previous_hash = nil
    expected_sequence = 1
    order(:sequence_number).each do |entry|
      raise "Missing entry! Expected sequence #{expected_sequence}, found #{entry.sequence_number}" if entry.sequence_number != expected_sequence

      expected = entry.send(:expected_hash, previous_hash)
      raise "Tampering detected at AuditLog##{entry.id}" if entry.entry_hash != expected

      previous_hash = entry.entry_hash
      expected_sequence += 1
    end
    true
  end

  private

  def compute_hash
    AuditLog.connection.execute("SELECT pg_advisory_xact_lock(#{CHAIN_LOCK_KEY})")

    last_entry = AuditLog.order(:sequence_number).last
    self.sequence_number = (last_entry&.sequence_number || 0) + 1
    self.previous_entry_hash = last_entry&.entry_hash
    self.created_at ||= Time.current
    self.entry_hash = expected_hash(previous_entry_hash)
  end

  def expected_hash(prev_hash)
    payload = [ prev_hash, sequence_number, action, auditable_type, auditable_id, user_id, changes_data.to_json, created_at ].join("|")
    Digest::SHA256.hexdigest(payload)
  end
end
