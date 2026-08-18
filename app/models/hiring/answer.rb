module Hiring
  class Answer < ApplicationRecord
    self.table_name = "hiring_answers"

    belongs_to :posting_application, class_name: "Hiring::PostingApplication"
    belongs_to :question, class_name: "Hiring::Question"
    has_one_attached :file

    validates :question_id, uniqueness: { scope: :posting_application_id }
    validate :must_be_answered_if_required

    private

    def must_be_answered_if_required
      return unless question&.required?

      if value.blank? && !file.attached?
        errors.add(:base, "must be answered because this question is required")
      end
    end
  end
end
