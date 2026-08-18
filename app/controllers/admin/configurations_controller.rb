module Admin
  class ConfigurationsController < ApplicationController
    layout "admin"
    before_action :authenticate_user!

    permission :edit, desc: "View organization configuration", auto_assign: [ "Super Admin" ]
    permission :update, desc: "Edit organization configuration", auto_assign: [ "Super Admin" ]

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
      permitted = params.require(:configuration).permit(:org_name, external_links: [ :label, :url, :icon ], enabled_modules: [])
      permitted[:external_links] = permitted[:external_links]&.reject { |link| link[:url].blank? }

      enabled = (permitted.delete(:enabled_modules) || []).reject(&:blank?)
      permitted[:disabled_modules] = Configuration::MODULES.keys - enabled
      permitted
    end
  end
end
