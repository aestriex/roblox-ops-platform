module Hiring
  class PostingApplication < ApplicationRecord
    self.table_name = "hiring_posting_applications"

    belongs_to :user
    belongs_to :job_posting, class_name: "Hiring::JobPosting"
    has_many :answers, class_name: "Hiring::Answer", dependent: :destroy

    validates :user_id, uniqueness: { scope: :job_posting_id }
  end
end
