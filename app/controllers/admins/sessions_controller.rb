class Admins::SessionsController < Devise::SessionsController

  def create
    if !current_admin
      log_in_failure
    else
      super
    end
  end

  private

  def respond_to_on_destroy
    redirect_to new_admin_session_path
    flash[:alert] = "Logged out."
  end

  def log_in_failure
    redirect_to new_admin_session_path
    flash[:alert] = "Email or Password is invalid"
  end

end
