class Api::V1::PayPalController < Api::V1::ApiController
  before_action :authorize_user

  def create_paypal_customer_account
    begin
      paypal_accounts = @current_user.paypal_partner_accounts
      if paypal_accounts.present?
        paypal_accounts.each do |account|
          if account.email == params[:email]
            @account_details = PayPalConnectAccountService.new.retrevie_paypal_customer_account(@current_user, account)
          end
        end
        @account_details = PayPalConnectAccountService.new.create_paypal_customer_account(@current_user, params[:email])
      else
        @account_details = PayPalConnectAccountService.new.create_paypal_customer_account(@current_user, params[:email])
      end
      render json: @account_details

    rescue Exception => e
      render json: { error:  e.message }, status: :unprocessable_entity
    end
  end

  def save_paypal_account_details
    return render json: { error: "Email is missing in params." }, status: :unprocessable_entity unless params[:email].present?
    return render json: { error: "Link is missing in params." }, status: :unprocessable_entity unless params[:link].present?
    pay_pal_connect_id = params[:link].split("/").last
    account_type = "partner-referrals"
    if @current_user.paypal_partner_accounts.pluck(:account_id).include?(pay_pal_connect_id) == true
      render json: { error: "Account with this ID already present!" }, status: :unprocessable_entity
    else
      account = @current_user.paypal_partner_accounts.build(account_id: pay_pal_connect_id, account_type: account_type, email: params[:email], is_default: true, payment_type: "paypal")
      if account.save
        return render json: { message: "Your Paypal Account has been connected.", data: account}, status: :ok
      else
        return render json: { error: "Your Paypal Account could not be connected." }, status: :unprocessable_entity
      end
    end
  end
  
  def transfer_amount
    begin
      response = PayPalPaymentService.new.transfer_amount(params["account_id"], params["payment_id"])
      render json: response
    rescue Exception => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def create_payment
    begin
      if @current_user.paypal_partner_accounts.present?
        email = @current_user.paypal_partner_accounts.where(is_default: true).last.email
      end
      response = PayPalPaymentService.new.create_payment(@current_user, email)
      render json: response
    rescue Exception => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def create_payout
    begin
      if @current_user.paypal_partner_accounts.present?
        email = @current_user.paypal_partner_accounts.last.email
      end
      response = PayPalPayOutsService.new.create_payout(email)

      render json: response
    rescue Exception => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end