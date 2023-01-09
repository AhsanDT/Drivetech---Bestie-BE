class Api::V1::CardsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_card_by_id, only: [:update, :destroy]

  def index
    cards = @current_user.cards
    render json: {
      message: 'Cards',
      data: cards
    }, status: :ok
  end

  def create
    customer = check_stripe_customer
    stripe_token = card_params[:token]
    holder_name = card_params[:card_holder_name]
    retrieve_token = Stripe::Token.retrieve(stripe_token)
    card_token = retrieve_token.card.id
    cards = Card.where(token: card_token)
    return render json: { message: 'Token is expired' }, status: :ok if cards.any?
    card = StripeService.create_card(customer.id, stripe_token)
    return render json: { message: "Card is not created on Stripe" }, status: :unprocessable_entity if card.blank?
    @card = create_user_card(card)
    make_first_card_as_default
    if @card
      render json: {
        message: 'Card created successfully',
        data: @card
      }, status: :ok
    else
      render json: {
        message: 'There are errors while creating card',
        error: @card.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @card.update(card_params)
      @current_user.cards.where.not(id: @card.id).update_all(default: false) if [true, "true"].include? params[:card][:default]
      StripeService.update_default(@current_user.stripe_customer_id, @card.token)
      render json: {
        message: 'Card updated successfully',
        data: @card
      }, status: :ok
    else
      render json: {
        message: 'There are errors while updating card',
        error: @card.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @card.destroy
      begin
        @current_user.cards.first.update(default: true) if @current_user.cards.present? && @card.default
        Stripe::Customer.delete_source(@current_user.stripe_customer_id, @card.token)
        StripeService.update_default(@current_user.stripe_customer_id, @current_user.cards.first.token)
      rescue => e
        return render json: { message: e.message }, status: :unprocessable_entity
      end

      render json: {
        message: 'card deleted',
      }, status: :ok
    end
  end

  private
  def find_card_by_id
    @card = Card.find_by_id(params[:id])
    return render json: {
      message: 'No card found'
    }, status: :unprocessable_entity unless @card.present?
  end

  def check_stripe_customer
    if @current_user.stripe_customer_id.present?
      begin
        customer = Stripe::Customer.retrieve(@current_user.stripe_customer_id)
      rescue => e
        return render json: {message: e}
      end
    else
      customer = StripeService.create_customer(card_params[:card_holder_name], @current_user.email)
      @current_user.update(stripe_customer_id: customer.id) rescue nil
    end
    return customer
  end

  def make_first_card_as_default
    @current_user.cards.update(default: true) if @current_user.cards.count < 2
  end

  def create_user_card(card)
    @current_user.cards.create(
      token: card.id, exp_month: card.exp_month,
      exp_year: card.exp_year, cvc: card.last4,
      brand: card.brand, country: card_params[:country],
      card_holder_name: card_params[:card_holder_name]
    )
  end

  def card_params
    params.require(:card).permit(:card_holder_name, :token, :country, :default)
  end
end
