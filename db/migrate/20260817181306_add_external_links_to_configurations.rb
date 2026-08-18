class AddExternalLinksToConfigurations < ActiveRecord::Migration[8.1]
  def change
    add_column :configurations, :external_links, :jsonb
  end
end
