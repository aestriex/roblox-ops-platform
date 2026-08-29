class AddAllowContractDeletionAnytimeToConfigurations < ActiveRecord::Migration[8.1]
  def change
    add_column :configurations, :allow_contract_deletion_anytime, :boolean, default: false, null: false
  end
end
