class CreatePersonnelContractParties < ActiveRecord::Migration[8.1]
  def change
    create_table :personnel_contract_parties, id: :uuid do |t|
      t.references :contract, null: false, foreign_key: { to_table: :personnel_contracts }, type: :uuid
      t.references :entity, polymorphic: true, null: true, type: :uuid
      t.string :custom_party_name
      t.string :role

      t.timestamps
    end
  end
end
