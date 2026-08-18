module Hiring
  class Section < ApplicationRecord
    self.table_name = "hiring_sections"

    belongs_to :job_posting, class_name: "Hiring::JobPosting"
    has_many :questions, class_name: "Hiring::Question", dependent: :destroy

    validates :title, presence: true
  end
end
