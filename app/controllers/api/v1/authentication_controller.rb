class Api::V1::AuthenticationController < Api::V1::ApiController
  before_action :authorize_user, except: [:sign_up, :login, :forgot_password, :verify_token, :reset_password]
  before_action :find_user_by_email, only: [:forgot_password, :verify_token, :reset_password]

  def sign_up
    @user = User.create(sign_up_params)
    if @user.errors.any?
      render json: {
        message: 'There are error while creating user',
        error: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(email: login_params[:email])
    if @user&.authenticate(login_params[:password])
      render json: {
        message: 'User logged in successfully',
        data: @user,
        auth_token: JsonWebToken.encode(user_id: @user.id)
      }, status: :ok
    else
      render json:{
        message: 'Invalid Email or Password'
      }, status: :unprocessable_entity
    end
  end

  def forgot_password
    generate_otp(@user)
    ForgotPasswordMailer.with(user: @user).forgot_password.deliver_now
    render json: {
      message: 'Forgot password token sent on your registered email',
      data: @user
    }, status: :ok
  end

  def verify_token
    if @user.otp == params[:otp].to_i && @user.otp_expiry >= Time.current && params[:otp].present?
      return render json: {
        message: "OTP verified",
        data: @user,
      }, status: :ok
    else
      return render json: {
        message: 'Invalid OTP',
      }, status: :unprocessable_entity
    end
  end

  def reset_password
    if params[:password].present? && @user.update(password: params[:password])
      render json: {
        message: 'Password updated successfully',
        data: @user
      }, status: :ok
    else
      render json: {
        message: 'There are errors while updaing password',
        error: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private
  def sign_up_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :location, :city, :country, :experience, :age,
                                 :sex, :rate, :phone_number, :pronoun, :latitude, :longitude, :profile_type, :profile_image,
                                 :id_front_image, :id_back_image, :selfie, portfolio: [], camera_detail_attributes: [ :id,
                                 :model, :camera_type, :others, equipment: [], talent: [] ], user_interests_attributes: [:id, :interest_id])
  end

  def login_params
    params.require(:user).permit(:email, :password)
  end

  def find_user_by_email
    @user = User.find_by(email: params[:email])
    render json: {
      message: 'No user found against this email'
    }, status: :unprocessable_entity unless @user.present?
  end

  def generate_otp(user)
    otp = (SecureRandom.random_number(9e5) + 1e5).to_i
    user.update( otp: otp, otp_expiry: (Time.current + 2.minutes))
  end

end
