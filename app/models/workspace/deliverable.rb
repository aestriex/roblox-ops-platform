module Workspace
  class Deliverable < ApplicationRecord
    self.table_name = "workspace_deliverables"

    belongs_to :feature
    belongs_to :milestone
    has_many :work_items, dependent: :restrict_with_error

    validates :name, presence: true

    include Filterable
    filterable_by :milestone_id, label: "Milestone", options: ->(project) { project.milestones.pluck(:name, :id) }
    filterable_by :feature_id, label: "Feature", options: ->(project) { project.features.pluck(:name, :id) }

    def dialog_form_id
      persisted? ? "deliverable_dialog_form_#{id}" : "deliverable_dialog_form_new"
    end
  end
end
