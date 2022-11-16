class Admins::SessionsController < Devise::SessionsController

  def create
    if !current_admin
      # if current_admin.status == 'inactive'
      #   unauthorized_admin
      # end
      log_in_failure
    else
      super
    end
  end

  private

  def respond_to_on_destroy
    redirect_with_message("Logged out.")
  end

  def log_in_failure
    redirect_with_message("Email or Password is invalid")
  end

  def unauthorized_admin
    redirect_with_message("You're not unauthorized to login")
  end

  def redirect_with_message(message)
    redirect_to new_admin_session_path
    flash[:alert] = message
  end
end
