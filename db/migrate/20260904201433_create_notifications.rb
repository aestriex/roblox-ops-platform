class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications, id: :uuid do |t|
      t.references :recipient, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.string :title, null: false
      t.text :body
      t.string :url
      t.references :notifiable, polymorphic: true, type: :uuid
      t.datetime :read_at

      t.timestamps
    end

    add_index :notifications, [ :recipient_id, :read_at ]
  end
end
