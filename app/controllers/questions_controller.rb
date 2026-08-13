class QuestionsController < ApplicationController
  layout "admin"

  before_action :authenticate_user!
  before_action :set_job_posting
  before_action :set_section

  def show
    @question = @section.questions.find(params[:id])
    render partial: "questions/question", locals: { question: @question }
  end

  def new
    @question = @section.questions.new
  end

  def create
    @question = @section.questions.new(question_params)

    if @question.save
      flash.now[:notice] = "Question added."
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to job_posting_path(@job_posting), notice: "Question added." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @question = @section.questions.find(params[:id])
  end

  def update
    @question = @section.questions.find(params[:id])

    if @question.update(question_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to job_posting_path(@job_posting), notice: "Question updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question = @section.questions.find(params[:id])
    @question.destroy
    redirect_to job_posting_path(@job_posting), notice: "Question removed."
  end

  def reorder
    params[:ids].each_with_index do |id, index|
      @section.questions.find(id).update!(position: index)
    end
    head :ok
  end

  private

  def set_job_posting
    @job_posting = JobPosting.find(params[:job_posting_id])
  end

  def set_section
    @section = @job_posting.sections.find(params[:section_id])
  end

  def question_params
    params.require(:question).permit(:label, :question_type, :required, :options, :position)
  end
end
