class ForgotPasswordMailer < ApplicationMailer
  def forgot_password
    @user = params[:user]
    mail(to: @user.email, subject: 'Forgot your password')
  end
end
