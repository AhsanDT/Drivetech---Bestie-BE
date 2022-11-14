class Api::V1::SocialLoginController < Api::V1::ApiController
  before_action :authorize_user, except: :social_login

  def social_login
    return render json: {message: "Invalid provider type"} unless %w[google facebook apple].include? params['provider']
    return render json: {message: "Invalid profile type"} unless %w[user bestie].include? params['profile_type']
    return render json: {message: 'Please provide social login token'}, status: :unprocessable_entity unless params['token'].present?
    response = SocialLoginService.new(params['provider'], params['token'], params['profile_type']).social_logins
    if response[0]&.class&.to_s == "User"
      @user = response[0]
      render json: {
        message: 'user created',
        data: response[0],
        auth_token: response[1],
        profile_image: @user&.profile_image&.attached? ? @user&.profile_image&.url : ""
      }, status: :ok
    else
      render json: { message: "Token has been Expired" }, status: :unprocessable_entity
    end
  end
end
