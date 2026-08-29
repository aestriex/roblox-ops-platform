module Personnel
  class ContractVersionsController < ApplicationController
    layout "admin"

    before_action :authenticate_user!
    before_action :set_contract

    permission :create, desc: "Upload a new contract version", auto_assign: [ "Manager", "Super Admin" ]

    def create
      @contract_version = @contract.contract_versions.build(contract_version_params)
      @contract_version.uploaded_by = current_user

      if @contract_version.save
        redirect_to personnel_contract_path(@contract), notice: "Version added."
      else
        render turbo_stream: turbo_stream.update("new_contract_version_dialog_form",
          partial: "personnel/contract_versions/form", locals: { contract: @contract, contract_version: @contract_version }),
          status: :unprocessable_entity
      end
    end

    private

    def set_contract
      @contract = Contract.find(params[:contract_id])
    end

    def contract_version_params
      params.require(:contract_version).permit(:status, :file)
    end
  end
end
