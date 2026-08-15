class CreateWorkspaceFeatures < ActiveRecord::Migration[8.1]
  def change
    create_table :workspace_features, id: :uuid do |t|
      t.references :project, type: :uuid, null: false, foreign_key: { to_table: :workspace_projects }
      t.string :name, null: false
      t.text :description
      t.timestamps
    end
  end
end
