class PostingApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job_posting
  has_many :answers, dependent: :destroy

  validates :user_id, uniqueness: { scope: :job_posting_id }
end
