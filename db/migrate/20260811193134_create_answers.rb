class CreateAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table :answers, id: :uuid do |t|
      t.references :posting_application, type: :uuid, null: false, foreign_key: true
      t.references :question, type: :uuid, null: false, foreign_key: true
      t.jsonb :value

      t.timestamps
    end

    add_index :answers, [ :posting_application_id, :question_id ], unique: true
  end
end
