module Workspace
  class Milestone < ApplicationRecord
    self.table_name = "workspace_milestones"

    belongs_to :project

    has_many :deliverables, dependent: :restrict_with_error

    validates :name, presence: true
    validates :target_date, presence: true
  end
end
