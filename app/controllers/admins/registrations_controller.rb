class Admins::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :require_no_authentication, only: [:cancel]
  prepend_before_action :authenticate_scope!, only: [:destroy]

  def new
    build_resource
    yield resource if block_given?
    render partial: 'devise/registrations/new', locals:{resource: resource}
  end

  def create
    build_resource(sign_up_params)
    resource.status = "active"
    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        redirect_to admins_sub_admins_path
        flash[:notice] = "SubAdmin has been created successfully."
      else
        set_flash_message! :alert, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)  and return
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      flash[:alert] = @admin.errors.full_messages.to_sentence
      redirect_to admins_sub_admins_path  and return
    end
  end
end
