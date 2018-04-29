class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Kích hoạt tài khoản"
  end

  def password_reset(user)
    @user = user

    debugger
    mail to: user.email, subject: "Thiết lập lại mật khẩu"
  end
end
