module Admin
  class UsersController < ApplicationController
    before_action :find_user, only: %i(edit update destroy)

    def index
      @users = User.paginate page: params[:page], per_page: 2
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new user_params
      if @user.save
        flash[:success] = t ".new_create"
        redirect_to admin_users_path
      else
        render :new
      end
    end

    def edit; end

    def update
      if @user.update_attributes user_params
        flash[:success] = t ".update_success"
        redirect_to admin_users_path
      else
        render :edit
      end
    end

    def destroy
      if @user.destroy
        flash[:success] = t ".del_success"
      else
        flash[:danger] = t ".del_danger"
      end
      redirect_to admin_users_path
    end

    private

    def user_params
      params.require(:user).permit :full_name, :email, :password, :password_confirmation
    end

    def find_user
      @user = User.find_by id: params[:id]
      return if @user
      flash[:danger] = t "admin.users.not_found_user"
      redirect_to admin_users_path
    end
  end
end
