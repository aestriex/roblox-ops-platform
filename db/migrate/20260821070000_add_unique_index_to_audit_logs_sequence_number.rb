class AddUniqueIndexToAuditLogsSequenceNumber < ActiveRecord::Migration[8.1]
  def change
    add_index :audit_logs, :sequence_number, unique: true
  end
end
