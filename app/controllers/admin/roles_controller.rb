module Admin
  class RolesController < ApplicationController
    layout "admin"

    before_action :authenticate_user!

    permission :index, desc: "View roles", auto_assign: ["Super Admin"]
    permission :show, desc: "View a role's permissions", auto_assign: ["Super Admin"]
    permission :edit, desc: "Access role permission editor", auto_assign: ["Super Admin"]
    permission :update, desc: "Change a role's permissions", key: "roles.manage", auto_assign: ["Super Admin"]

    def index
      @roles = Role.all
    end

    def show
      @role = Role.find(params[:id])
    end

    def edit
      @role = Role.find(params[:id])
      @all_permissions = Permission.all
    end

    def update
      @role = Role.find(params[:id])
      Rails.logger.info "DEBUG PARAMS: #{params.inspect}"
      permission_ids = params[:permission_ids] || []
      @role.permissions = Permission.where(id: permission_ids)
      redirect_to admin_role_path(@role), notice: "Permissions updated."
    end
  end
end
