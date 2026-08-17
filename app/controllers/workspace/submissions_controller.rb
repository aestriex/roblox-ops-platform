module Workspace
  class SubmissionsController < ApplicationController
    layout "admin"

    before_action :authenticate_user!
    before_action :set_project
    before_action :set_feature
    before_action :set_deliverable
    before_action :set_work_item

    permission :create, desc: "Submit work for a workspace work item", auto_assign: ["Manager", "Super Admin"]
    permission :destroy, desc: "Delete workspace submissions", auto_assign: ["Super Admin"]

    def create
      @submission = @work_item.submissions.new(submission_params)
      @submission.submitted_by_id ||= current_user.personnel_person&.id

      if @submission.save
        redirect_to workspace_project_feature_deliverable_work_item_path(@project, @feature, @deliverable, @work_item), notice: "Submission added successfully."
      else
        @submissions = @work_item.submissions.includes(:submitted_by).order(created_at: :desc)
        @people = Personnel::Person.all
        render turbo_stream: turbo_stream.update(@submission.dialog_form_id,
          partial: "workspace/submissions/form", locals: { project: @project, feature: @feature, deliverable: @deliverable, work_item: @work_item, submission: @submission, people: @people }),
          status: :unprocessable_entity
      end
    end

    def destroy
      @submission = @work_item.submissions.find(params[:id])

      @submission.destroy

      redirect_to workspace_project_feature_deliverable_work_item_path(@project, @feature, @deliverable, @work_item), notice: "Submission deleted successfully."
    end

    private

    def submission_params
      params.require(:submission).permit(:notes, :submitted_by_id, :package)
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

    def set_work_item
      @work_item = @deliverable.work_items.find(params[:work_item_id])
    end
  end
end
