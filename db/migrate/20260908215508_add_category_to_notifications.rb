class AddCategoryToNotifications < ActiveRecord::Migration[8.1]
  def change
    add_column :notifications, :category, :string
  end
end
