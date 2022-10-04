class Api::V1::SessionsController < Api::V1::ApiController
  before_action :authorize_user, except: :login

  def login
    @user = User.find_by(email: user_params[:email])
    if @user&.authenticate(user_params[:password])
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

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
