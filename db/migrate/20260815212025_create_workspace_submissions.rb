class CreateWorkspaceSubmissions < ActiveRecord::Migration[8.1]
  def change
    create_table :workspace_submissions, id: :uuid do |t|
      t.references :work_item, type: :uuid, null: false, foreign_key: { to_table: :workspace_work_items }
      t.references :submitted_by, type: :uuid, foreign_key: { to_table: :personnel_people }, null: false
      t.text :notes
      t.timestamps
    end
  end
end
