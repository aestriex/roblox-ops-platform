class RenameHiringTables < ActiveRecord::Migration[8.1]
  def change
    rename_table :job_postings, :hiring_job_postings
    rename_table :sections, :hiring_sections
    rename_table :questions, :hiring_questions
    rename_table :answers, :hiring_answers
    rename_table :posting_applications, :hiring_posting_applications

    reversible do |dir|
      dir.up do
        execute "UPDATE active_storage_attachments SET record_type = 'Hiring::Answer' WHERE record_type = 'Answer'"
      end
      dir.down do
        execute "UPDATE active_storage_attachments SET record_type = 'Answer' WHERE record_type = 'Hiring::Answer'"
      end
    end
  end
end
