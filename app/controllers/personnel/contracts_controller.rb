module Personnel
  class ContractsController < ApplicationController
    layout "admin"

    before_action :authenticate_user!

    permission :index, desc: "View all contracts", auto_assign: [ "Manager", "Super Admin" ]
    permission :show, desc: "View a contract", auto_assign: [ "Manager", "Super Admin" ]
    permission :new, desc: "Add a contract", auto_assign: [ "Manager", "Super Admin" ]
    permission :create, desc: "Create new personnel contracts", auto_assign: [ "Manager", "Super Admin" ]
    permission :edit, desc: "Access the edit contract form", auto_assign: [ "Manager", "Super Admin" ]
    permission :update, desc: "Edit personnel contracts", auto_assign: [ "Manager", "Super Admin" ]
    permission :destroy, desc: "Delete personnel contracts", auto_assign: [ "Super Admin" ]

    def index
      @contracts = Contract.includes(contract_parties: :entity).apply_filters(filter_params)
    end

    def show
      @contract = Contract.find(params[:id])
    end

    def new
      @contract = Contract.new(status: "draft")
    end

    def create
      @contract = Contract.new(contract_params.merge(status: "draft"))

      if @contract.save
        redirect_to personnel_contract_path(@contract), notice: "Contract created successfully."
      else
        render turbo_stream: turbo_stream.update(@contract.dialog_form_id,
          partial: "personnel/contracts/form", locals: { contract: @contract }),
          status: :unprocessable_entity
      end
    end

    def edit
      @contract = Contract.find(params[:id])
    end

    def update
      @contract = Contract.find(params[:id])

      if @contract.update(contract_params)
        redirect_to personnel_contract_path(@contract), notice: "Contract updated successfully."
      else
        render turbo_stream: turbo_stream.update(@contract.dialog_form_id,
          partial: "personnel/contracts/form", locals: { contract: @contract }),
          status: :unprocessable_entity
      end
    end

    def destroy
      @contract = Contract.find(params[:id])

      unless @contract.deletable?
        return redirect_to personnel_contract_path(@contract), alert: "This contract can only be deleted once terminated."
      end

      if @contract.destroy
        redirect_to personnel_contracts_path, notice: "Contract deleted."
      else
        redirect_to personnel_contract_path(@contract), alert: @contract.errors.full_messages.to_sentence
      end
    end

    private

    def contract_params
      params.require(:contract).permit(:id, :name, :description, :status, :start_date, :end_date,
        contract_parties_attributes: [ :id, :entity_selector, :custom_party_name, :role, :_destroy ])
    end

    def filter_params
      params.permit(:status)
    end
  end
end
