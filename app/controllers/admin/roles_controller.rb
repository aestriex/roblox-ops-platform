module Admin
  class RolesController < ApplicationController
    layout "admin"

    before_action :authenticate_user!
    before_action :can_manage_role!, only: [:edit, :update, :destroy]

    permission :index, desc: "View roles", auto_assign: ["Super Admin"]
    permission :show, desc: "View a role's permissions", auto_assign: ["Super Admin"]
    permission :new, desc: "Access the new role form", auto_assign: ["Super Admin"]
    permission :create, desc: "Create new roles", auto_assign: ["Super Admin"]
    permission :edit, desc: "Access role permission editor", auto_assign: ["Super Admin"]
    permission :update, desc: "Change a role's permissions", key: "roles.manage", auto_assign: ["Super Admin"]
    permission :destroy, desc: "Delete roles", auto_assign: ["Super Admin"]

    def index
      @roles = Role.all
      @all_permissions = Permission.all
    end

    def show
      @role = Role.find(params[:id])
    end

    def new
      @role = Role.new
      @all_permissions = Permission.all
    end

    def create
      @role = Role.new(role_params.except(:permission_ids))

      if @role.save
        @role.permissions = Permission.where(id: role_params[:permission_ids] || [])
        redirect_to admin_roles_path, notice: "Role created successfully."
      else
        @all_permissions = Permission.all
        render turbo_stream: turbo_stream.update(@role.dialog_form_id,
          partial: "admin/roles/form", locals: { role: @role, all_permissions: @all_permissions }),
          status: :unprocessable_entity
      end
    end

    def edit
      @role = Role.find(params[:id])
      @all_permissions = Permission.all
    end

    def update
      @role = Role.find(params[:id])

      if @role.update(role_params.except(:permission_ids))
        @role.permissions = Permission.where(id: role_params[:permission_ids] || [])
        redirect_to admin_roles_path, notice: "Role updated successfully."
      else
        @all_permissions = Permission.all
        render turbo_stream: turbo_stream.update(@role.dialog_form_id,
          partial: "admin/roles/form", locals: { role: @role, all_permissions: @all_permissions }),
          status: :unprocessable_entity
      end
    end

    def destroy
      @role = Role.find(params[:id])
      @role.destroy
      redirect_to admin_roles_path, notice: "Role deleted."
    end

    private

    def role_params
      params.require(:role).permit(:name, :description, permission_ids: [])
    end

    def can_manage_role
      target_role = Role.find(params[:id])
      if target_role.rank >= current_user.highest_role.rank
        redirect_to admin_roles_path, alert: "You cannot manage a role equal to or higher than your own."
      end
    end
  end
end
