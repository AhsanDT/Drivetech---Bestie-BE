class Api::V1::SocialLoginController < Api::V1::ApiController
  before_action :authorize_user, except: :social_login

  def social_login
    return render json: {message: "Invalid provider type"} unless %w[google facebook apple].include? params['provider']
    return render json: {message: 'Please provide social login token'}, status: :unprocessable_entity unless params['token'].present?
    response = SocialLoginService.new(params['provider'], params['token']).social_logins
    if response[0]&.class&.to_s == "User"
      render json: {
        message: 'user created',
        data: response[0],
        auth_token: response[1]
      }, status: :ok
    else
      render json: { message: "Token has been Expired" }, status: :unprocessable_entity
    end
  end
end
