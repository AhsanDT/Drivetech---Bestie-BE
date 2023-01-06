class Api::V1::NotificationsController < Api::V1::ApiController
  before_action :authorize_user

  def notification_mobile_token
    if params[:mobile_token].present?
      token = @current_user.mobile_devices.find_or_create_by(mobile_token: params[:mobile_token])
      @current_user.update(latitude: params[:latitude], longitude: params[:longitude])
      if token.save
        render json: { message: "Successesfully Created" }
      end
    end
  end

  def get_notifications
    @notifications = @current_user.notifications
  end
end