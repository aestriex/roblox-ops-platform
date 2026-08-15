class CreateWorkspaceDeliverables < ActiveRecord::Migration[8.1]
  def change
    create_table :workspace_deliverables, id: :uuid do |t|
      t.references :feature, type: :uuid, null: false, foreign_key: { to_table: :workspace_features }
      t.references :milestone, type: :uuid, null: false, foreign_key: { to_table: :workspace_milestones }
      t.string :name, null: false
      t.text :description
      t.timestamps
    end
  end
end
