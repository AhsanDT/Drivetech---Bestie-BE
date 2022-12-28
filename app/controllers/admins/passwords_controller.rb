class Admins::PasswordsController < Devise::PasswordsController

  def custom_reset_password_action
  end

  protected
  def after_sending_reset_password_instructions_path_for(resource_name)
    reset_password_instruction_path
  end
end