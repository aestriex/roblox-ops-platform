class CreateWorkspaceWorkItems < ActiveRecord::Migration[8.1]
  def change
    create_table :workspace_work_items, id: :uuid do |t|
      t.references :deliverable, type: :uuid, null: false, foreign_key: { to_table: :workspace_deliverables }
      t.references :assignee, type: :uuid, foreign_key: { to_table: :personnel_people }, null: true
      t.string :title, null: false
      t.text :description
      t.string :status, null: false, default: "backlog"
      t.boolean :blocked, null: false, default: false
      t.text :blocked_reason
      t.date :due_date
      t.timestamps
    end
  end
end
