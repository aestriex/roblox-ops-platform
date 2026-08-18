class CreatePostingApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :posting_applications, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :job_posting, type: :uuid, null: false, foreign_key: true
      t.string :status, null: false, default: "in_progress"
      t.datetime :submitted_at

      t.timestamps
    end

    add_index :posting_applications, [ :user_id, :job_posting_id ], unique: true
  end
end
