class Api::V1::PaymentsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_user, only: [:transfer]
  before_action :find_card, only: [:create]

  def create
    begin
      @charge = StripePaymentService.create_charge((((params[:amount]).to_f) * 100).to_i, params[:card], @current_user.stripe_connect_id)
    rescue => e
      return render json: { error: e.message }
    end

    render json: { charge: @charge, transfer: @transfer }
  end

  def transfer
    begin
      @transfer = StripePaymentService.create_transfer((((params[:amount]).to_f) * 100).to_i, @user.stripe_connect_id)
    rescue => e
      return render json: { error: e.message }
    end

    render json: { transfer: @transfer }
  end

  private

  def find_user
    @user = User.find_by(id: params[:user_id])
  end

  def find_card
    @card = @current_user.cards.first.token
  end
end