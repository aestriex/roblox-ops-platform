module Public
  class PostingApplicationsController < ApplicationController
    layout "public_application"

    restrict_to_module :hiring

    before_action :authenticate_user!, except: [ :index ]
    before_action :set_job_posting, except: [ :index ]
    before_action :ensure_open!, except: [ :complete, :index ]
    before_action :ensure_editable!, only: [ :show, :update ], except: [ :index ]
    before_action :set_section, except: [ :index ]

    def index
      @postings = Hiring::JobPosting.where(status: "open")
    end

    def show
      head :not_found and return unless @section
    end

    def update
      application = current_user.posting_applications.find_or_create_by(job_posting: @job_posting)

      results = @section.questions.map do |question|
        answer = application.answers.find_or_initialize_by(question: question)

        if question.question_type == "file_upload"
          uploaded_file = params.dig(:answers, question.id.to_s)
          answer.file.attach(uploaded_file) if uploaded_file.present?
        else
          answer.value = params[:answers]&.[](question.id.to_s)
        end

        answer.save
      end

      if results.all?
        if @current_index < @sections.size - 1
          redirect_to apply_path(slug: @job_posting.slug, section_position: @current_index + 2)
        else
          application.update(status: "submitted", submitted_at: Time.current)
          redirect_to apply_complete_path(slug: @job_posting.slug), notice: "Application submitted!"
        end
      else
        flash.now[:alert] = "Please complete all required questions."
        render :show, status: :unprocessable_entity
      end
    end

    def complete
      @application = current_user.posting_applications.find_by(job_posting: @job_posting)
    end

    private

    def set_job_posting
      @job_posting = Hiring::JobPosting.find_by!(slug: params[:slug])
    end

    def ensure_open!
      render "public/posting_applications/unavailable", status: :ok and return if @job_posting.status != "open"
    end

    def set_section
      @sections = @job_posting.sections.order(:position)
      @current_index = params[:section_position].to_i - 1
      @section = @sections[@current_index]

      application = current_user.posting_applications.find_by(job_posting: @job_posting)
      @answers = application ? application.answers.index_by(&:question_id) : {}
    end

    def ensure_editable!
      application = current_user.posting_applications.find_by(job_posting: @job_posting)
      if application&.status == "submitted"
        redirect_to apply_complete_path(slug: @job_posting.slug) and return
      end
    end
  end
end
