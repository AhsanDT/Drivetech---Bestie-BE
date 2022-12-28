class Admins::SessionsController < Devise::SessionsController

  def create
    if !current_admin
      if  !user_params[:password].present? && !user_params[:email].present?
        flash[:alert] = {email: "Email can't be blank",password: "Password can't be blank"}
      elsif !user_params[:email].present?
        flash[:alert] = {email: "Email can't be blank"}
      elsif !user_params[:password].present?
        flash[:alert] = { password: "Password can't be blank"}
      else
        flash[:alert] = {email: "Email can't be blank",password: "Password can't be blank"}
      end
      redirect_to new_admin_session_path
    else
      super
    end
  end

  private

  def user_params
    params.require(:admin).permit(:email,:password)
  end

end
