module Workspace
  class MilestonesController < ApplicationController
    layout "admin"

    before_action :authenticate_user!
    before_action :set_project

    permission :index, desc: "View all project milestones", auto_assign: ["Super Admin"]
    permission :new, desc: "Add a project milestone", auto_assign: ["Super Admin"]
    permission :create, desc: "Create new project milestones", auto_assign: ["Super Admin"]
    permission :edit, desc: "Stage project milestones", auto_assign: ["Manager", "Super Admin"]
    permission :update, desc: "Edit project milestones", auto_assign: ["Manager", "Super Admin"]
    permission :destroy, desc: "Delete project milestones", auto_assign: ["Super Admin"]

    def index
      @milestones = @project.milestones
    end

    def new
      @milestone = @project.milestones.new
    end

    def create
      @milestone = @project.milestones.new(milestone_params)

      if @milestone.save
        redirect_to workspace_project_path(@project), notice: "Milestone created successfully."
      else
        render turbo_stream: turbo_stream.update(@milestone.dialog_form_id,
          partial: "workspace/milestones/form", locals: { project: @project, milestone: @milestone }),
          status: :unprocessable_entity
      end
    end

    def edit
      @milestones = @project.milestones.find(params[:id])
    end

    def update
      @milestone = @project.milestones.find(params[:id])

      if @milestone.update(milestone_params)
        redirect_to workspace_project_path(@project), notice: "Milestone updated successfully."
      else
        render turbo_stream: turbo_stream.update(@milestone.dialog_form_id,
          partial: "workspace/milestones/form", locals: { project: @project, milestone: @milestone }),
          status: :unprocessable_entity
      end
    end

    def destroy
      @milestone = @project.milestones.find(params[:id])

      @milestone.destroy

      redirect_to workspace_project_path(@project), notice: "Milestone deleted successfully."
    end

    private

    def milestone_params
      params.require(:milestone).permit(:name, :description, :target_date)
    end

    def set_project
      @project = Project.find(params[:project_id])
    end
  end
end
