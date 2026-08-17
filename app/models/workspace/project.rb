module Workspace
  class Project < ApplicationRecord
    self.table_name = "workspace_projects"

    has_many :milestones, dependent: :destroy
    has_many :features, dependent: :destroy
    has_many :deliverables, through: :features
    has_many :work_items, through: :deliverables
    has_many :submissions, through: :work_items

    validates :name, presence: true

    def dialog_form_id
      persisted? ? "project_dialog_form_#{id}" : "project_dialog_form_new"
    end
  end
end
