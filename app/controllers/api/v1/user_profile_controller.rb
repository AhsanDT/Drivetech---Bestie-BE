class Api::V1::UserProfileController < Api::V1::ApiController
  before_action :authorize_user

  def get_profile
    @user = @current_user
  end

  def get_profile_image; end

  def get_camera_detail; end

  def get_portfolio; end
end