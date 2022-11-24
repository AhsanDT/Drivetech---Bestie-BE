class Api::V1::StripeConnectController < Api::V1::ApiController
  before_action :authorize_user

  def connect
    begin
      @account = StripeConnectService.create_connect_account("US", @current_user.email, params[:return_url], @current_user, connect_api_v1_stripe_connect_index_url)
    rescue => e
      return render json: { error: e.message }
    end
    render json: { message: "Connect account has been created", data: @account.url }
  end

  def get_connect_account
    begin
      @account = StripeConnectService.retrieve_account(@current_user.stripe_connect_id)
    rescue => e
      return render json: { error: e.message }
    end
    render json: {account: @account}
  end

  def create_login_link
    begin
      @link = StripeConnectService.login_link(@current_user.stripe_connect_id)
    rescue => e
      return render json: { error: e.message }
    end
    render json: {data: @link}
  end
end