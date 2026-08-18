class AddDisabledModulesToConfigurations < ActiveRecord::Migration[8.1]
  def change
    add_column :configurations, :disabled_modules, :jsonb, default: [], null: false
  end
end
