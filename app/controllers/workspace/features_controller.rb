module Workspace
  class FeaturesController < ApplicationController
    layout "admin"

    before_action :authenticate_user!
    before_action :set_project

    permission :index, desc: "View all workspace features", auto_assign: [ "Super Admin" ]
    permission :show, desc: "View a workspace feature", auto_assign: [ "Super Admin" ]
    permission :new, desc: "Add a workspace feature", auto_assign: [ "Super Admin" ]
    permission :create, desc: "Create new workspace features", auto_assign: [ "Super Admin" ]
    permission :edit, desc: "Stage workspace feature edits", auto_assign: [ "Manager", "Super Admin" ]
    permission :update, desc: "Edit workspace features", auto_assign: [ "Manager", "Super Admin" ]
    permission :destroy, desc: "Delete workspace features", auto_assign: [ "Super Admin" ]

    def index
      @features = @project.features.apply_filters(filter_params)
    end

    def show
      @feature = @project.features.find(params[:id])
    end

    def new
      @feature = @project.features.new
    end

    def create
      @feature = @project.features.new(feature_params)

      if @feature.save
        redirect_to workspace_project_feature_path(@project, @feature), notice: "Feature created successfully."
      else
        render turbo_stream: turbo_stream.update(@feature.dialog_form_id,
          partial: "workspace/features/form", locals: { project: @project, feature: @feature }),
          status: :unprocessable_entity
      end
    end

    def edit
      @feature = @project.features.find(params[:id])
    end

    def update
      @feature = @project.features.find(params[:id])

      if @feature.update(feature_params)
        redirect_to workspace_project_feature_path(@project, @feature), notice: "Feature updated successfully."
      else
        render turbo_stream: turbo_stream.update(@feature.dialog_form_id,
          partial: "workspace/features/form", locals: { project: @project, feature: @feature }),
          status: :unprocessable_entity
      end
    end

    def destroy
      @feature = @project.features.find(params[:id])

      @feature.destroy

      redirect_to workspace_project_path(@project), notice: "Feature deleted successfully."
    end

    private

    def feature_params
      params.require(:feature).permit(:name, :description)
    end

    def filter_params
      params.permit(:milestone_id)
    end

    def set_project
      @project = Project.find(params[:project_id])
    end
  end
end
