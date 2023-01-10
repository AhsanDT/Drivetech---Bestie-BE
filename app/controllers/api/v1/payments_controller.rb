class Api::V1::PaymentsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_user, only: [:transfer]
  before_action :find_card, only: [:create]
  before_action :find_default_payment, only: [:make_default_payment, :create_payment]
  before_action :find_default_card, only: [:create_payment]

  def make_default_payment
    begin
      if @default_payment.present?
        @default_payment.update(payment_type: params[:payment_type])
      else
        @default_payment = DefaultPayment.create(payment_type: params[:payment_type], user_id: @current_user.id)
      end
      render json: { data: @default_payment }
    rescue => e
      return render json: {error: e}
    end
  end

  def create_payment
    begin
      if @default_payment.payment_type == "card"
        @payment = StripeService.create_charge_by_card((((params[:amount]).to_f) * 100).to_i, @current_user.stripe_customer_id)
        render json: { data: @payment }
      elsif @default_payment.payment_type == "apple_pay"
        @payment_intent = ApplePayService.apple_pay((((params[:amount]).to_f) * 100).to_i)
        render json: { data: @payment_intent }
      elsif @default_payment.payment_type == "paypal"
        render json: { message: "Payment using paypal" }
      end
    rescue => e
      return render json: { error: e.message }
    end
  end

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

  def find_default_card
    @card = @current_user.cards.where(default: true)
  end

  def find_default_payment
    @default_payment = @current_user.default_payment
  end
end