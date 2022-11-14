class Api::V1::ProfileController < Api::V1::ApiController
  before_action :authorize_user

  def update_profile
    @profile = @current_user
    unless @profile.update(profile_params)
      render json: {
        message: 'There are error while updating profile',
        error: @profile.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def switch_user
    if params[:profile_type] == "user"
      if @current_user.profile_type == "bestie"
        @current_user.update(profile_type: "user")
      else
        render json: { message: "User type is already end user" }
      end
    elsif params[:profile_type] == "bestie"
      if @current_user.profile_type == "user"
        if @current_user.camera_detail.present? && @current_user.user_talents.present? && @current_user.social_media.present? && @current_user.portfolio.present? && @current_user.rate.present?
          @current_user.update(profile_type: "bestie")
        else
          @current_user.update(profile_type: "bestie", profile_completed: "false")
        end
      else
        render json: { message: "User type is already bestie" }
      end
    end
  end

  def update_user_interests
    if @current_user.interests.present?
      user_interest_ids = @current_user.interests.ids - params[:interest_ids].split(',')
      user_interest_ids.each do |delete_user_interest|
        delete_user_interest = UserInterest.find_by(interest_id: delete_user_interest)
        delete_user_interest.destroy
      end
    end
    params[:interest_ids].split(',').each do |interest_id|
      @user_interests = @current_user.user_interests.find_or_create_by(interest_id: interest_id)
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:email, :password, :first_name, :last_name, :location, :city, :country, :experience, :age,
                                    :sex, :rate, :phone_number, :pronoun, :latitude, :longitude, :profile_image,
                                    :id_front_image, :id_back_image, :selfie, portfolio: [], camera_detail_attributes: [ :id,
                                    :model, :camera_type, others: [] , equipment: [] ], user_interests_attributes: [:id, :interest_id],
                                    user_talents_attributes: [:id, :talent_id], social_media_attributes: [:id, :title, :link])
  end
end
