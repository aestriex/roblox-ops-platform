class CreateNotificationPreferences < ActiveRecord::Migration[8.1]
  def change
    create_table :notification_preferences, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :category, null: false
      t.boolean :enabled, null: false, default: true

      t.timestamps
    end

    add_index :notification_preferences, [ :user_id, :category ], unique: true
  end
end
