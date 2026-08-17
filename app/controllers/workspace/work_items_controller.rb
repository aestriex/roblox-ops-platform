module Workspace
  class WorkItemsController < ApplicationController
    layout "admin"

    before_action :authenticate_user!
    before_action :set_project
    before_action :set_feature
    before_action :set_deliverable

    permission :show, desc: "View a workspace work item", auto_assign: ["Super Admin"]
    permission :new, desc: "Add a workspace work item", auto_assign: ["Super Admin"]
    permission :create, desc: "Create new workspace work items", auto_assign: ["Super Admin"]
    permission :edit, desc: "Stage workspace work item edits", auto_assign: ["Manager", "Super Admin"]
    permission :update, desc: "Edit workspace work items", auto_assign: ["Manager", "Super Admin"]
    permission :destroy, desc: "Delete workspace work items", auto_assign: ["Super Admin"]

    def show
      @work_item = @deliverable.work_items.find(params[:id])
      @submissions = @work_item.submissions.includes(:submitted_by).order(created_at: :desc)
    end

    def new
      @work_item = @deliverable.work_items.new
      @assignees = Personnel::Person.all
    end

    def create
      @work_item = @deliverable.work_items.new(work_item_params)

      if @work_item.save
        redirect_to workspace_project_feature_deliverable_work_item_path(@project, @feature, @deliverable, @work_item), notice: "Work item created successfully."
      else
        @assignees = Personnel::Person.all
        render turbo_stream: turbo_stream.update(@work_item.dialog_form_id,
          partial: "workspace/work_items/form", locals: { project: @project, feature: @feature, deliverable: @deliverable, work_item: @work_item, assignees: @assignees }),
          status: :unprocessable_entity
      end
    end

    def edit
      @work_item = @deliverable.work_items.find(params[:id])
      @assignees = Personnel::Person.all
    end

    def update
      @work_item = @deliverable.work_items.find(params[:id])

      if @work_item.update(work_item_params)
        redirect_to workspace_project_feature_deliverable_work_item_path(@project, @feature, @deliverable, @work_item), notice: "Work item updated successfully."
      else
        @assignees = Personnel::Person.all
        render turbo_stream: turbo_stream.update(@work_item.dialog_form_id,
          partial: "workspace/work_items/form", locals: { project: @project, feature: @feature, deliverable: @deliverable, work_item: @work_item, assignees: @assignees }),
          status: :unprocessable_entity
      end
    end

    def destroy
      @work_item = @deliverable.work_items.find(params[:id])

      @work_item.destroy

      redirect_to workspace_project_feature_deliverable_path(@project, @feature, @deliverable), notice: "Work item deleted successfully."
    end

    private

    def work_item_params
      params.require(:work_item).permit(:title, :description, :status, :assignee_id, :due_date, :blocked, :blocked_reason)
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_feature
      @feature = @project.features.find(params[:feature_id])
    end

    def set_deliverable
      @deliverable = @feature.deliverables.find(params[:deliverable_id])
    end
  end
end
