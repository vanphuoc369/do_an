class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Kích hoạt tài khoản thành công!"
      redirect_to user
    else
      flash[:danger] = "Kích hoạt tài khoản thất bại."
      redirect_to root_url
    end
  end
end
