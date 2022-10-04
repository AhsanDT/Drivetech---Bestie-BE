class Api::V1::RegistrationsController < Api::V1::ApiController
  before_action :authorize_user, except: :create

  def create
    @user = User.create!(user_params)
    if @user.errors.any?
      render json: {
        message: 'There are error while creating user',
        error: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :location, :city, :country, :experience, :age,
                                 :sex, :rate, :phone_number, :pronoun, :latitude, :longitude, :profile_type, :profile_image,
                                 :id_front_image, :id_back_image, :selfie, portfolio: [], camera_detail_attributes: [ :id,
                                 :model, :camera_type, :others, equipment: [], talent: [] ])
  end

end
