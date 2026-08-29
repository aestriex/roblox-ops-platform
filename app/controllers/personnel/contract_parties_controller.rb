module Personnel
  class ContractPartiesController < ApplicationController
    layout "admin"

    before_action :authenticate_user!
    before_action :set_contract

    permission :create, desc: "Add a party to a contract", auto_assign: [ "Manager", "Super Admin" ]
    permission :destroy, desc: "Remove a party from a contract", auto_assign: [ "Manager", "Super Admin" ]

    def create
      @contract_party = @contract.contract_parties.build(contract_party_params)

      if @contract_party.save
        redirect_to personnel_contract_path(@contract), notice: "Party added."
      else
        render turbo_stream: turbo_stream.update("new_contract_party_dialog_form",
          partial: "personnel/contract_parties/form", locals: { contract: @contract, contract_party: @contract_party }),
          status: :unprocessable_entity
      end
    end

    def destroy
      @contract_party = @contract.contract_parties.find(params[:id])

      if @contract.contract_parties.count <= 1
        redirect_to personnel_contract_path(@contract), alert: "A contract must have at least one party."
      else
        @contract_party.destroy
        redirect_to personnel_contract_path(@contract), notice: "Party removed."
      end
    end

    private

    def set_contract
      @contract = Contract.find(params[:contract_id])
    end

    def contract_party_params
      params.require(:contract_party).permit(:entity_selector, :custom_party_name, :role)
    end
  end
end
