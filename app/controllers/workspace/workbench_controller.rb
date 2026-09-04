module Workspace
  class WorkbenchController < ApplicationController
    layout "admin"

    before_action :authenticate_user!

    permission :index, desc: "Access personal work assignments", auto_assign: [ "Super Admin" ]
    permission :work_item, desc: "View own work item details from Workbench", auto_assign: [ "Super Admin" ]

    def index
      person = current_user.personnel_person

      if person.nil?
        @work_items = Workspace::WorkItem.none
      else
        @work_items = Workspace::WorkItem.joins(deliverable: { feature: :project }).where(assignee: person)
        @work_items = @work_items.where(feature: { project_id: params[:project_id] }) if params[:project_id].present?
      end

      @projects_for_filter = Workspace::Project.joins(features: { deliverables: :work_items }).where(workspace_work_items: { assignee_id: person&.id }).distinct
    end

    def work_item
      person = current_user.personnel_person
      raise ActiveRecord::RecordNotFound if person.nil?

      @work_item = Workspace::WorkItem.joins(deliverable: { feature: :project }).where(assignee: person).find(params[:id])

      if turbo_frame_request?
        render "work_item", layout: false
      end
    end
  end
end
