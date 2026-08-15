class CreatePersonnelPeople < ActiveRecord::Migration[8.1]
  def change
    create_table :personnel_people, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, null: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :position
      t.string :department
      t.string :status, null: false, default: "active"
      t.date :start_date
      t.date :end_date
      t.text :notes

      t.timestamps
    end
  end
end
