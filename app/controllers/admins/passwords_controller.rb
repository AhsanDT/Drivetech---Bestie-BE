class Admins::PasswordsController < Devise::PasswordsController

  def custom_reset_password_action
  end

  def create
    @admin = Admin.find_by(email: params[:admin][:email])
    if @admin.present?
      super
    else
      redirect_to new_admin_password_path
    end
  end

  protected
  def after_sending_reset_password_instructions_path_for(resource_name)
    reset_password_instruction_path
  end
end