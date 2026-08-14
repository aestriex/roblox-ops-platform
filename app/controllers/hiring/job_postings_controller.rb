module Hiring
  class JobPostingsController < ApplicationController
    layout "admin"
    before_action :authenticate_user!

    permission :index, desc: "View job postings list", auto_assign: ["Staff", "Manager", "Super Admin"]
    permission :new, desc: "Access the new job posting form", auto_assign: ["Manager", "Super Admin"]
    permission :create, desc: "Create new job postings", auto_assign: ["Manager", "Super Admin"]
    permission :edit, desc: "Access the edit job posting form", auto_assign: ["Staff", "Manager", "Super Admin"]
    permission :update, desc: "Edit job postings", auto_assign: ["Staff", "Manager", "Super Admin"]
    permission :destroy, desc: "Delete job postings", key: "forms.delete", auto_assign: ["Super Admin"]
    permission :update_status, desc: "Change job posting status (publish/close/reopen)", auto_assign: ["Staff", "Manager", "Super Admin"]

    def index
      @job_postings = JobPosting.all
    end

    def show
      @job_posting = JobPosting.find(params[:id])
    end

    def new
      @job_posting = JobPosting.new
    end

    def create
      @job_posting = JobPosting.new(job_posting_params)

      if @job_posting.save
        redirect_to hiring_job_posting_path(@job_posting), notice: "Job posting created successfully."
      else
        render turbo_stream: turbo_stream.replace("job_posting_dialog_form",
          partial: "hiring/job_postings/form", locals: { job_posting: @job_posting }),
          status: :unprocessable_entity
      end
    end

    def edit
      @job_posting = JobPosting.find(params[:id])
    end

    def update
      @job_posting = JobPosting.find(params[:id])

      if @job_posting.update(job_posting_params)
        redirect_to hiring_job_posting_path(@job_posting), notice: "Job posting updated successfully."
      else
        render turbo_stream: turbo_stream.replace("job_posting_dialog_form",
          partial: "hiring/job_postings/form", locals: { job_posting: @job_posting }),
          status: :unprocessable_entity
      end
    end

    def destroy
      @job_posting = JobPosting.find(params[:id])
      @job_posting.destroy
      redirect_to hiring_job_postings_path, notice: "Job posting deleted."
    end

    def update_status
      @job_posting = JobPosting.find(params[:id])
      @job_posting.update!(status: params[:status])
      redirect_to hiring_job_posting_path(@job_posting), notice: "Job posting status updated."
    end

    def new_button
      render "hiring/sections/new_button", layout: false
    end

    private

    def job_posting_params
      params.require(:job_posting).permit(:title, :description, :department, :status)
    end
  end
end
