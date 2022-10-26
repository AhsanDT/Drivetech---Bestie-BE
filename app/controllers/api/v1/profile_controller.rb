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

  private
  def profile_params
    params.require(:profile).permit(:email, :password, :first_name, :last_name, :location, :city, :country, :experience, :age,
                                    :sex, :rate, :phone_number, :pronoun, :latitude, :longitude, :profile_image,
                                    :id_front_image, :id_back_image, :selfie, portfolio: [], camera_detail_attributes: [ :id,
                                    :model, :camera_type, others: [] , equipment: [] ], user_interests_attributes: [:id, :interest_id],
                                    user_talents_attributes: [:id, :talent_id], social_media_attributes: [:id, :title, :link])
  end

end
