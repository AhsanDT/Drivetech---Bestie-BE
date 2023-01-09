class Api::V1::BanksController < Api::V1::ApiController
  before_action :authorize_user
  before_action :set_bank, only: %i[ show update destroy ]

  def index
    banks = @current_user.banks.all
    render json: banks
  end

  def show
    render json: @bank
  end

  def create
    customer = get_stripe_customer
    bank = create_customer_bank(customer)

    if ['true', true].include? params[:default] 
      bank.user.banks.where.not(id: bank.id).update_all(default: false)
      bank.update(default: true)
    end
    if !bank[:message].present?
      begin
        bank_account = StripeService.retrive_bank(bank.user.stripe_customer_id, bank.bank_id)
        response = bank_account.verify({ amounts: [32, 45] })
      rescue => e
        return render json: e.message
      end

      return render json: { bank: bank, message: "Bank has been saved successfully." }
    else
      render json: { message: bank[:message] }, status: :unprocessable_entity
    end
  end

  def update
    if @bank.update(bank_params)
      @current_user.banks.where.not(id: @bank.id).update_all(default: false) if [true, "true"].include? params[:default]
      StripeService.update_default(@current_user.stripe_customer_id, @bank.bank_id)
      render json: { message: "Account has been updated successfully!", bank: @bank }
    else
      render json: @bank.errors, status: :unprocessable_entity
    end
  end

  def destroy
    customer = get_stripe_customer
    bank_id = @bank.bank_id
    if @bank.destroy
      begin
        @current_user.banks.first.update(default: true) if @current_user.banks.present? && @bank.default
        Stripe::Customer.delete_source(customer.id, bank_id)
        StripeService.update_default(customer.id, bank_id)
      rescue => e
        return render json: { message: e.message }, status: :unprocessable_entity
      end

      render json: { message: "Account has been deleted successfully!" }
    end
  end

  private

  def set_bank
    begin
      @bank = Bank.find(params[:id])
    rescue
      return render json: { message: "Account not found!" }, status: :not_found
    end
  end

  def bank_params
    params.permit(:id, :country, :currency, :account_holder_name, :account_holder_type, :routing_number, :account_number, :bank_name, :default)
  end

  def get_stripe_customer
    if @current_user.stripe_customer_id.present?
      begin
        customer = Stripe::Customer.retrieve(@current_user.stripe_customer_id)
      rescue => e
        return render json: { message: e.message }
      end
    else
      begin
        customer = StripeService.create_customer(bank_params[:account_holder_name], @current_user.email)
      rescue => e
        return render json: { message: e.message }
      end
      @current_user.update(stripe_customer_id: customer.id)
    end

    customer
  end

  def create_customer_bank(customer)
    account_holder_type = "individual"

    begin
      bank_id = Stripe::Token.create({
        bank_account: {
          country: params[:country],
          currency: params[:currency],
          account_holder_name: params[:account_holder_name],
          account_holder_type: account_holder_type,
          routing_number: params[:routing_number],
          account_number: params[:account_number],
        },
      })
      data = StripeService.create_bank(customer.id, bank_id)
    rescue => e
      return { message: e.message }
    end

    bank = Bank.create(country: data.country, currency: data.currency, account_holder_name: data.account_holder_name,
                       account_holder_type: account_holder_type, routing_number: data.routing_number,
                       user_id: @current_user.id, bank_id: data.id, account_number: params[:account_number],
                       bank_name: data.bank_name)

    bank.update(default: true) if [true, "true"].include? params[:default] || @current_user.banks.count == 1

    bank
  end
end
