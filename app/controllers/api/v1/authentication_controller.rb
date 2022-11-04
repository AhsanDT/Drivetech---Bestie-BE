class Api::V1::AuthenticationController < Api::V1::ApiController
  before_action :authorize_user, except: [:sign_up, :uniq_email_and_phone, :uniq_phone_number, :login, :forgot_password, :verify_token, :reset_password, :update_social_login, :get_interests, :get_talents]
  before_action :find_user_by_email, only: [:forgot_password, :verify_token, :reset_password, :update_social_login]
  PHONE_NUMBER_REGEX = /[!@#$%^&*(),.?":{}|<>]/

  def sign_up
    begin
      @user = User.create(sign_up_params.merge(profile_completed: true, login_type: 'manual'))
    rescue => e
      return render json: {
        message: 'There are error while creating user',
        error: e.message
      }, status: :unprocessable_entity
    end
    if @user.errors.any?
      render json: {
        message: 'There are error while creating user',
        error: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def uniq_email_and_phone
    if params[:user][:phone_number] =~ PHONE_NUMBER_REGEX
      render json: { error: "Please enter the valid phone number" }, status: :unprocessable_entity
    else
      @phone = User.find_by(phone_number: params[:user][:phone_number]) if params[:user][:phone_number]
      @email = User.find_by(email: params[:user][:email]) if params[:user][:email]
      if @phone.present? && @email.present?
        render json: { error: 'Both email and phone number are not unique'}, status: :unprocessable_entity
      elsif @email.present?
        render json: {error: 'Email has already been taken' }, status: :unprocessable_entity
      elsif @phone.present?
        render json: { error: 'Phone number has already been taken' }, status: :unprocessable_entity
      else
        render json: { message: 'Unique email and phone number' }, status: 200
      end
    end
  end

  def uniq_phone_number
    if params[:user][:phone_number] =~ PHONE_NUMBER_REGEX
      render json: { error: "Please enter the valid phone number" }, status: :unprocessable_entity
    else
      @phone = User.find_by(phone_number: params[:user][:phone_number]) if params[:user][:phone_number]
      if @phone.present?
        render json: { error: 'Phone number has already been taken' }, status: :unprocessable_entity
      else
        render json: { message: 'Unique phone number' }, status: :ok
      end
    end
  end

  def login
    @user = User.find_by(email: login_params[:email])
    if @user&.authenticate(login_params[:password])
      if !@user.profile_completed?
        render json: {
          message: 'Please complete your profile first'
        },status: :ok
      end
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

  def update_social_login
    @user.update(sign_up_params.merge(profile_completed: true))
    if @user.errors.any?
      render json: {
        message: 'There are error while updating user',
        error: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def get_interests
    @interest = Interest.all
    if @interest.nil?
      render json: {
        message: 'All interests',
        data: []
      }, status: :ok
    end
  end

  def get_talents
    @talent = Talent.all
    if @talent.nil?
      render json: {
        message: 'All talents',
        data: []
      }, status: :ok
    end
  end

  private
  def sign_up_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :location, :city, :country, :experience, :age,
                                 :sex, :rate, :phone_number, :pronoun, :latitude, :longitude, :profile_type, :profile_image,
                                 :id_front_image, :id_back_image, :selfie, portfolio: [], camera_detail_attributes: [ :id,
                                 :model, :camera_type, others: [] , equipment: [] ], user_interests_attributes: [:id, :interest_id],
                                 user_talents_attributes: [:id, :talent_id], social_media_attributes: [:id, :title, :link])
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
