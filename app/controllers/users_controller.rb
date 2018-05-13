class UsersController < ApplicationController
    before_action :load_user, only: [:show, :update, :edit]
    before_action :check_user_logged, only: :new
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Bạn đã đăng ký thành công. Kiểm tra email để kích hoạt tài khoản."
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @activities = Activity.your_activities @user.id
    @activities = collection_paginate @activities, params[:page], 5
  end

  def update
    if @user.full_name == params[:user][:full_name]
      flash[:info] = "Bạn có thể cập nhật lại họ tên."
      redirect_to @user
    elsif @user.update_attribute(:full_name, params[:user][:full_name])
      flash[:success] = "Cập nhật thông tin thành công!"
      redirect_to @user
    else
      flash[:danger] = "Cập nhật không thành công, vui lòng kiểm tra lại thông tin cập nhật."
      redirect_to user_path(params[:id])
    end
  end

  def edit
  end

  private

  def user_params
    params.require(:user).permit :full_name, :email, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = "Không tìm thấy người này"
    redirect_to root_path
  end

  def check_user_logged
    if logged_in?
      flash[:warning] = "Bạn đang đăng nhập vào hệ thống"
      redirect_to current_user
    end
  end
end
