class Api::V1::UserProfileController < Api::V1::ApiController
  before_action :authorize_user
  before_action :besties, only: [:search_by_name]
  before_action :end_users, only: [:search_by_name]

  def get_profile; end

  def get_profile_image; end

  def get_camera_detail; end

  def get_portfolio; end

  def get_user_profile
    @user = User.find_by(id: params[:user_id])
  end

  def search_by_name
    if params[:name].present?
      if @current_user.profile_type == "bestie"
        @users = end_users.where('full_name ILIKE ?',  "%#{params[:name]}%")
      else
        @users = besties.where('full_name ILIKE ?',  "%#{params[:name]}%")
      end
    else
      if @current_user.profile_type == 'user'
        @users = besties.first(10)
      else
        @users = end_users.first(10)
      end
    end
    @users
  end

  private

  def besties
    User.bestie_users
  end

  def end_users
    User.end_users
  end
end