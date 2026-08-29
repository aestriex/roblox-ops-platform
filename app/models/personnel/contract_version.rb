module Personnel
  class ContractVersion < ApplicationRecord
    self.table_name = "personnel_contract_versions"

    STATUSES = Personnel::Contract::STATUSES

    belongs_to :contract, class_name: "Personnel::Contract"
    belongs_to :uploaded_by, class_name: "User", optional: true

    has_one_attached :file

    before_validation :assign_version_number, on: :create

    validates :status, presence: true, inclusion: { in: STATUSES }
    validates :version_number, presence: true, uniqueness: { scope: :contract_id }
    validate :file_must_be_attached

    before_update :prevent_mutation
    before_destroy :prevent_mutation

    after_create :sync_contract_status

    def label
      "Version #{version_number} — #{status.titleize}"
    end

    def status_badge_classes
      Personnel::Contract::STATUS_BADGE_CLASSES.fetch(status, "bg-muted text-muted-foreground")
    end

    private

    def assign_version_number
      self.version_number ||= (contract&.contract_versions&.maximum(:version_number) || 0) + 1
    end

    def sync_contract_status
      contract.update_column(:status, status)
    end

    def file_must_be_attached
      errors.add(:file, "must be attached") unless file.attached?
    end

    def prevent_mutation
      errors.add(:base, "contract versions cannot be modified or deleted once created")
      throw :abort
    end
  end
end
