module Admin
  class UsersController < ApplicationController
    layout "admin"

    before_action :authenticate_user!

    permission :index, desc: "View all users", auto_assign: [ "Super Admin" ]
    permission :edit, desc: "Access user role editor", auto_assign: [ "Super Admin" ]
    permission :update, desc: "Change a user's roles", key: "users.manage", auto_assign: [ "Super Admin" ]

    def index
      @users = User.all
    end

    def show
      @user = User.find(params[:id])
    end

    def edit
      @user = User.find(params[:id])
      @all_roles = Role.all
    end

    def update
      @user = User.find(params[:id])
      role_ids = params[:role_ids] || []
      @user.roles = Role.where(id: role_ids)
      redirect_to admin_users_path, notice: "Roles updated for #{@user.display_name}."
    end
  end
end
