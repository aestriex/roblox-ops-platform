class CreateConfigurations < ActiveRecord::Migration[8.1]
  def change
    create_table :configurations, id: :uuid do |t|
      t.string :org_name

      t.timestamps
    end
  end
end
