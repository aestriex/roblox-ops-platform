class CreateWorkspaceProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :workspace_projects, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.timestamps
    end
  end
end
