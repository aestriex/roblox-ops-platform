module Workspace
  class DeliverablesController < ApplicationController
    layout "admin"

    before_action :authenticate_user!
    before_action :set_project
    before_action :set_feature, if: -> { params[:feature_id].present? }

    permission :show, desc: "View a workspace deliverable", auto_assign: [ "Super Admin" ]
    permission :new, desc: "Add a workspace deliverable", auto_assign: [ "Super Admin" ]
    permission :create, desc: "Create new workspace deliverables", auto_assign: [ "Super Admin" ]
    permission :edit, desc: "Stage workspace deliverable edits", auto_assign: [ "Manager", "Super Admin" ]
    permission :update, desc: "Edit workspace deliverables", auto_assign: [ "Manager", "Super Admin" ]
    permission :destroy, desc: "Delete workspace deliverables", auto_assign: [ "Super Admin" ]

    def index
      @deliverables = Workspace::Deliverable.joins(:feature).where(feature: { project_id: @project.id }).apply_filters(filter_params)
    end

    def show
      @deliverable = @project.deliverables.find(params[:id])
    end

    def new
      @deliverable = @feature ? @feature.deliverables.new : Workspace::Deliverable.new
      @features = @project.features unless @feature
    end

    def create
      @feature ||= @project.features.find(deliverable_params[:feature_id])
      @deliverable = @feature.deliverables.new(deliverable_params)

      if @deliverable.save
        redirect_to workspace_project_deliverable_path(@project, @deliverable), notice: "Deliverable created successfully."
      else
        @features = @project.features
        render turbo_stream: turbo_stream.update(@deliverable.dialog_form_id,
          partial: "workspace/deliverables/form", locals: { project: @project, feature: @feature, deliverable: @deliverable, features: @features }),
          status: :unprocessable_entity
      end
    end

    def edit
      @deliverable = @feature.deliverables.find(params[:id])
    end

    def update
      @deliverable = @feature.deliverables.find(params[:id])

      if @deliverable.update(deliverable_params)
        redirect_to workspace_project_feature_deliverable_path(@project, @feature, @deliverable), notice: "Deliverable updated successfully."
      else
        render turbo_stream: turbo_stream.update(@deliverable.dialog_form_id,
          partial: "workspace/deliverables/form", locals: { project: @project, feature: @feature, deliverable: @deliverable }),
          status: :unprocessable_entity
      end
    end

    def destroy
      @deliverable = @feature.deliverables.find(params[:id])

      @deliverable.destroy

      redirect_to workspace_project_feature_path(@project, @feature), notice: "Deliverable deleted successfully."
    end

    private

    def deliverable_params
      params.require(:deliverable).permit(:name, :description, :milestone_id, :feature_id)
    end

    def filter_params
      params.permit(:milestone_id, :feature_id)
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_feature
      @feature = @project.features.find(params[:feature_id])
    end
  end
end
