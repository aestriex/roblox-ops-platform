module Admin
  class ConfigurationsController < ApplicationController
    layout "admin"
    before_action :authenticate_user!

    permission :edit, desc: "View organization configuration", auto_assign: ["Super Admin"]
    permission :update, desc: "Edit organization configuration", auto_assign: ["Super Admin"]

    def edit
      @configuration = Configuration.instance
    end

    def update
      @configuration = Configuration.instance
      if @configuration.update(configuration_params)
        redirect_to edit_admin_configurations_path, notice: "Application configuration updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def configuration_params
      params.require(:configuration).permit(:org_name)
    end
  end
end
