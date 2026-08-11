class AddSlugToJobPostings < ActiveRecord::Migration[8.1]
  def change
    add_column :job_postings, :slug, :string
    add_index :job_postings, :slug, unique: true
  end
end
