module Admin
  class UsersController < ApplicationController
    before_action :find_user, only: %i(edit update destroy)

    def index
      @users = User.all_users
      respond_to do |format|
        format.html
        format.js
      end
    end

    def new
      @user = User.new
      respond_to do |format|
        format.html
        format.js
      end
    end

    def create
      @user = User.new user_params
      if @user.save
        flash.now[:success] = "Thêm tài khoản người dùng thành công"
      else
        flash.now[:danger] = "Thêm tài khoản người dùng không thành công"
      end
      @users = User.all_users
      respond_to do |format|
        format.html
        format.js
      end
    end

    def edit
      respond_to do |format|
        format.html
        format.js
      end
    end

    def update
      if @user.update_attributes user_params
        flash.now[:success] = "Cập nhật thông tin người dùng thành công"
      else
        flash.now[:danger] = "Cập nhật thông tin người dùng không thành công"
      end
      @users = User.all_users
      respond_to do |format|
        format.html
        format.js
      end
    end

    def destroy
      if @user.destroy
        flash.now[:success] = "Xóa người dùng thành công"
      else
        flash.now[:danger] = "Xóa người dùng không thành công"
      end
      @users = User.all_users
      respond_to do |format|
        format.html
        format.js
      end
    end

    private

    def user_params
      params.require(:user).permit :full_name, :email, :password, :password_confirmation, :activated
    end

    def find_user
      @user = User.find_by id: params[:id]
      return if @user
      flash.now[:danger] = "Không tìm thấy người dùng"
      redirect_to admin_users_path
    end
  end
end
