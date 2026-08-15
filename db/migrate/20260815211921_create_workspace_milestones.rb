class CreateWorkspaceMilestones < ActiveRecord::Migration[8.1]
  def change
    create_table :workspace_milestones, id: :uuid do |t|
      t.references :project, type: :uuid, null: false, foreign_key: { to_table: :workspace_projects }
      t.string :name, null: false
      t.date :target_date
      t.boolean :locked, null: false, default: false
      t.timestamps
    end
  end
end
