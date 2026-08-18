module Hiring
  class JobPosting < ApplicationRecord
    self.table_name = "hiring_job_postings"

    has_many :sections, class_name: "Hiring::Section", dependent: :destroy
    has_many :questions, through: :sections
    has_many :posting_applications, class_name: "Hiring::PostingApplication", dependent: :destroy
    has_many :answers, through: :posting_applications

    validates :title, presence: true
    validates :department, presence: true
    validates :description, presence: true
    validates :status, presence: true, inclusion: { in: %w[draft open closed] }

    before_create :generate_slug

    def status_badge_classes
      case status
      when "open" then "bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200"
      when "closed" then "bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200"
      when "draft" then "bg-muted text-muted-foreground"
      end
    end

    private

    def generate_slug
      base = title.parameterize
      candidate = base
      counter = 2

      while Hiring::JobPosting.exists?(slug: candidate)
        candidate = "#{base}-#{counter}"
        counter += 1
      end

      self.slug = candidate
    end
  end
end
