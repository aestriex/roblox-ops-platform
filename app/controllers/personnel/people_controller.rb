module Personnel
  class PeopleController < ApplicationController
    layout "admin"

    before_action :authenticate_user!

    permission :index, desc: "View all people", auto_assign: [ "Staff", "Manager", "Super Admin" ]
    permission :new, desc: "Add a person", auto_assign: [ "Manager", "Super Admin" ]
    permission :create, desc: "Create new personnel records", auto_assign: [ "Manager", "Super Admin" ]
    permission :edit, desc: "Access the edit person form", auto_assign: [ "Manager", "Super Admin" ]
    permission :update, desc: "Edit personnel records", auto_assign: [ "Manager", "Super Admin" ]
    permission :destroy, desc: "Delete personnel records", auto_assign: [ "Super Admin" ]

    def index
      @people = Person.all
    end

    def new
      @person = Person.new
    end

    def create
      @person = Person.new(person_params)

      if @person.save
        redirect_to personnel_people_path, notice: "Person created successfully."
      else
        render turbo_stream: turbo_stream.update(@person.dialog_form_id,
          partial: "personnel/people/form", locals: { person: @person }),
          status: :unprocessable_entity
      end
    end

    def edit
      @person = Person.find(params[:id])
    end

    def update
      @person = Person.find(params[:id])

      if @person.update(person_params)
        redirect_to personnel_people_path, notice: "Person updated successfully."
      else
        render turbo_stream: turbo_stream.update(@person.dialog_form_id,
          partial: "personnel/people/form", locals: { person: @person }),
          status: :unprocessable_entity
      end
    end

    def destroy
      @person = Person.find(params[:id])
      @person.destroy
      redirect_to personnel_people_path, notice: "Person deleted."
    end

    private

    def person_params
      params.require(:person).permit(:first_name, :last_name, :department, :position, :status, :user_id, :start_date, :end_date, :notes)
    end
  end
end
