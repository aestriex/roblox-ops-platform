module Workspace
  class WorkItem < ApplicationRecord
    self.table_name = "workspace_work_items"

    belongs_to :deliverable
    belongs_to :assignee, class_name: "Personnel::Person", optional: true
    has_many :submissions, dependent: :destroy

    STATUSES = %w[backlog assigned in_progress in_review integrated published]

    validates :title, presence: true
    validates :status, inclusion: { in: STATUSES }

    def dialog_form_id
      persisted? ? "work_item_dialog_form_#{id}" : "work_item_dialog_form_new"
    end
  end
end
