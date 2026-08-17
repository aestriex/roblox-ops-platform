module Workspace
  class Feature < ApplicationRecord
    self.table_name = "workspace_features"

    belongs_to :project

    has_many :deliverables, dependent: :restrict_with_error
    has_many :work_items, through: :deliverables
    has_many :submissions, through: :work_items

    validates :name, presence: true

    def dialog_form_id
      persisted? ? "feature_dialog_form_#{id}" : "feature_dialog_form_new"
    end
  end
end
