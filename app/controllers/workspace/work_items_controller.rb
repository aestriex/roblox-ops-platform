module Workspace
  class WorkItemsController < ApplicationController
    layout "admin"

    before_action :authenticate_user!
    before_action :set_project
    before_action :set_feature, except: [ :show ]
    before_action :set_deliverable, except: [ :show ]

    permission :show, desc: "View a workspace work item", auto_assign: [ "Super Admin" ]
    permission :new, desc: "Add a workspace work item", auto_assign: [ "Super Admin" ]
    permission :create, desc: "Create new workspace work items", auto_assign: [ "Super Admin" ]
    permission :edit, desc: "Stage workspace work item edits", auto_assign: [ "Manager", "Super Admin" ]
    permission :update, desc: "Edit workspace work items", auto_assign: [ "Manager", "Super Admin" ]
    permission :destroy, desc: "Delete workspace work items", auto_assign: [ "Super Admin" ]

    permission :mark_backlog, desc: "Move work item to Backlog", auto_assign: [], guard: false
    permission :mark_assigned, desc: "Move work item to Assigned", auto_assign: [ "Manager", "Super Admin" ], guard: false
    permission :mark_in_progress, desc: "Move work item to In Progress", auto_assign: [], guard: false
    permission :mark_in_review, desc: "Move work item to In Review", auto_assign: [], guard: false
    permission :mark_integrated, desc: "Move work item to Integrated", auto_assign: [ "Manager", "Super Admin" ], guard: false
    permission :mark_published, desc: "Move work item to Published", auto_assign: [ "Super Admin" ], guard: false

    permission :update_description, desc: "Edit work item description inline", auto_assign: [ "Manager", "Super Admin" ]
    permission :update_due_date, desc: "Edit work item due date inline", auto_assign: [ "Manager", "Super Admin" ]
    permission :update_assignee, desc: "Edit work item assignee inline", auto_assign: [ "Manager", "Super Admin" ]

    def show
      @work_item = @project.work_items.find(params[:id])

      if turbo_frame_request?
        render "show", layout: false
      end
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

    def update_status
      @work_item = @project.work_items.find(params[:id])
      new_status = params[:status]

      allowed = current_user.can?("workspace/work_items.mark_#{new_status}") || @work_item.assignee&.user == current_user

      if allowed && @work_item.update(status: new_status)
        render turbo_stream: turbo_stream.replace("work_item_status_#{@work_item.id}",
          partial: "workspace/work_items/status_field", locals: { work_item: @work_item })
      else
        head :forbidden
      end
    end

    def update_description
      @work_item = @project.work_items.find(params[:id])
      @work_item.update(description: params[:description])
      render "show", layout: false
    end

    def update_due_date
      @work_item = @project.work_items.find(params[:id])
      @work_item.update(due_date: params[:due_date])
      render "show", layout: false
    end

    def update_assignee
      @work_item = @project.work_items.find(params[:id])
      @work_item.update(assignee_id: params[:assignee_id])
      render "show", layout: false
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
