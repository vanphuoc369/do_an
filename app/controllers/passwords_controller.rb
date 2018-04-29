class PasswordsController < ApplicationController
  include LoginsHelper
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
    if logged_in?
      flash[:warning] = "Bạn đăng nhập vào hệ thống. Cân nhắc việc đăng xuất để thiết lập lại mật khẩu."
      redirect_to current_user
    end
  end

  def edit
  end

  def create
    @user = User.find_by(email: params[:password][:email].downcase)
    if @user
      unless @user.reset_send_at.nil?
        if @user.reset_send_at > 6.hours.ago
          flash.now[:danger] = "Bạn đã gửi yêu cầu gần đây, vui lòng kiểm tra Email hoặc gửi lại yêu cầu sau 6 tiếng."
          render :new
        else
          send_require_reset_pass
        end
      else
        send_require_reset_pass
      end

    else
      flash.now[:danger] = "Không tìm thấy địa chỉ Email"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "không được để trống.")
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.set_nil_for_reset_send_at
      flash[:success] = "Mật khẩu đã được cập nhật thành công!"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      @user.set_nil_for_reset_send_at
      flash[:danger] = "Liên kết để thiết lập lại mật khẩu đã hết hạn."
      redirect_to new_password_url
    end
  end

  def send_require_reset_pass
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:success] = "Thông tin đã được gửi đến Email của bạn. Vui lòng kiểm tra Email trong vòng 6 giờ để thiết lập lại mật khẩu."
    redirect_to root_url
  end
end
