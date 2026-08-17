module Workspace
  class ProjectsController < ApplicationController
    layout "admin"

    before_action :authenticate_user!

    permission :index, desc: "View all workspace projects", auto_assign: ["Super Admin"]
    permission :show, desc: "View a workspace project", auto_assign: ["Super Admin"]
    permission :new, desc: "Add a workspace project", auto_assign: ["Super Admin"]
    permission :create, desc: "Create new workspace projects", auto_assign: ["Super Admin"]
    permission :edit, desc: "Stage workspace project edits", auto_assign: ["Manager", "Super Admin"]
    permission :update, desc: "Edit workspace projects", auto_assign: ["Manager", "Super Admin"]
    permission :destroy, desc: "Delete workspace projects", auto_assign: ["Super Admin"]

    def index
      @projects = Project.all
    end

    def show
      @project = Project.find(params[:id])
    end

    def new
      @project = Project.new
    end

    def create
      @project = Project.new(project_params)

      if @project.save
        redirect_to workspace_projects_path, notice: "Project created successfully."
      else
        render turbo_stream: turbo_stream.update(@project.dialog_form_id,
          partial: "workspace/projects/form", locals: { project: @project }),
          status: :unprocessable_entity
      end
    end

    def edit
      @project = Project.find(params[:id])
    end

    def update
      @project = Project.find(params[:id])

      if @project.update(project_params)
        redirect_to workspace_projects_path, notice: "Project details updated successfully."
      else
        render turbo_stream: turbo_stream.update(@project.dialog_form_id,
          partial: "workspace/projects/form", locals: { project: @project }),
          status: :unprocessable_entity
      end
    end

    def destroy
      @project = Project.find(params[:id])

      @project.destroy

      redirect_to workspace_projects_path, notice: "Project deleted successfully."
    end

    private

    def project_params
      params.require(:project).permit(:name, :description)
    end
  end
end
