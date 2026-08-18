class AddRankToRoles < ActiveRecord::Migration[8.1]
  def change
    add_column :roles, :rank, :integer
  end
end
