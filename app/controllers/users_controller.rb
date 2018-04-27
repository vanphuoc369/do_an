class UsersController < ApplicationController
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

  end

  private

  def user_params
    params.require(:user).permit :full_name, :email, :password, :password_confirmation
  end
end
