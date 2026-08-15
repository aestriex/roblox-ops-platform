module Workspace
  class Deliverable < ApplicationRecord
    self.table_name = "workspace_deliverables"

    belongs_to :feature
    belongs_to :milestone
    has_many :work_items, dependent: :restrict_with_error

    validates :name, presence: true
  end
end
