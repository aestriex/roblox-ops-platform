module Hiring
  class PostingApplicationsController < ApplicationController
    layout "admin"

    before_action :authenticate_user!
    before_action :set_job_posting

    permission :index, desc: "View applications for a job posting", auto_assign: [ "Staff", "Manager", "Super Admin" ]
    permission :show, desc: "View an individual applicant's submission", auto_assign: [ "Staff", "Manager", "Super Admin" ]

    def index
      @posting_applications = @job_posting.posting_applications.includes(:user).order(created_at: :desc)
    end

    def show
      @posting_application = @job_posting.posting_applications.find(params[:id])
    end

    def destroy
      @posting_application = @job_posting.posting_applications.find(params[:id])
      @posting_application.destroy
      redirect_to hiring_job_posting_path(@job_posting), notice: "Submission deleted."
    end

    private

    def set_job_posting
      @job_posting = JobPosting.find(params[:job_posting_id])
    end
  end
end
