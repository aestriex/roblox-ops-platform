class CreateAuditLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :audit_logs, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, null: true
      t.string :action, null: false
      t.string :auditable_type, null: false
      t.string :auditable_id, null: false
      t.bigint :sequence_number, null: false
      t.jsonb :changes_data
      t.string :entry_hash, null: false
      t.string :previous_entry_hash

      t.timestamps
    end

    add_index :audit_logs, [ :auditable_type, :auditable_id ]
  end
end
