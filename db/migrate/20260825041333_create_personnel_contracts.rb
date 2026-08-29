class CreatePersonnelContracts < ActiveRecord::Migration[8.1]
  def change
    create_table :personnel_contracts, id: :uuid do |t|
      t.string :name
      t.text :description
      t.string :status
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
