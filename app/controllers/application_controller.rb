class ApplicationController < ActionController::Base
  include LoginsHelper
  protect_from_forgery with: :exception

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = "Xin vui lòng đăng nhập tài khoản"
    redirect_to login_url
  end

  def check_login_or_save_url url
    unless logged_in?
      session[:forwarding_url] = url
      flash[:danger] = "Xin vui lòng đăng nhập tài khoản"
      redirect_to login_url
    end
  end
end
