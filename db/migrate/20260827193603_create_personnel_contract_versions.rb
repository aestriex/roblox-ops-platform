class CreatePersonnelContractVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :personnel_contract_versions, id: :uuid do |t|
      t.references :contract, null: false, foreign_key: { to_table: :personnel_contracts }, type: :uuid
      t.integer :version_number, null: false
      t.string :status, null: false
      t.references :uploaded_by, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end

    add_index :personnel_contract_versions, [ :contract_id, :version_number ], unique: true
  end
end
