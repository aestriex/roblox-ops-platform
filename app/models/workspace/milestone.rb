module Workspace
  class Milestone < ApplicationRecord
    self.table_name = "workspace_milestones"

    belongs_to :project

    has_many :deliverables, dependent: :restrict_with_error

    validates :name, presence: true
    validates :target_date, presence: true

    def dialog_form_id
      persisted? ? "milestone_dialog_form_#{id}" : "milestone_dialog_form_new"
    end
  end
end
