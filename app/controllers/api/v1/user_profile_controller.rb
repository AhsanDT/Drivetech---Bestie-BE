class Api::V1::UserProfileController < Api::V1::ApiController
  before_action :authorize_user

  def get_profile; end

  def get_profile_image; end

  def get_camera_detail; end

  def get_portfolio; end

  def get_user_profile
    @user = User.find_by(id: params[:user_id])
  end

  def search_by_name
    @users = User.where(full_name: params[:name])
    render json: {data: @users}
  end
end