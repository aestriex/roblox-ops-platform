module Workspace
  class WorkItem < ApplicationRecord
    self.table_name = "workspace_work_items"

    belongs_to :deliverable
    belongs_to :assignee, class_name: "Personnel::Person", optional: true
    has_many :submissions, dependent: :destroy

    include Filterable
    filterable_by :status, label: "Status", options: ->(*) { STATUSES.map { |s| [ s.titleize, s ] } }
    filterable_by :assignee_id, label: "Assignee", options: ->(project) { Personnel::Person.joins(:assigned_work_items).where(assigned_work_items: { deliverable: project.deliverables }).distinct.pluck(:first_name, :id) }
    filterable_by :feature_id, label: "Feature",
      options: ->(project) { project.features.pluck(:name, :id) },
      scope: ->(relation, value) { relation.joins(:deliverable).where(deliverable: { feature_id: value }) }
    filterable_by :milestone_id, label: "Milestone",
      options: ->(project) { project.milestones.pluck(:name, :id) },
      scope: ->(relation, value) { relation.joins(:deliverable).where(deliverable: { milestone_id: value }) }

    STATUSES = %w[backlog assigned in_progress in_review integrated published]

    validates :title, presence: true
    validates :status, inclusion: { in: STATUSES }

    def dialog_form_id
      persisted? ? "work_item_dialog_form_#{id}" : "work_item_dialog_form_new"
    end
  end
end
