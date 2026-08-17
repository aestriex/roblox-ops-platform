module Workspace
  class Submission < ApplicationRecord
    self.table_name = "workspace_submissions"

    belongs_to :work_item
    belongs_to :submitted_by, class_name: "Personnel::Person"
    has_one_attached :package

    validates :notes, presence: true

    def dialog_form_id
      persisted? ? "submission_dialog_form_#{id}" : "submission_dialog_form_new"
    end
  end
end
