class PayPalPaymentService < BaseService

  def initialize
    super
  end

  def create_payment(current_user, email, amount = 10.00, spotswap_fee = 1.00)
    total_amount = amount + spotswap_fee
    uri = URI.parse("https://api-m.sandbox.paypal.com/v1/payments/payment")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{@token}"
    request.body = JSON.dump({
                               "intent" => "sale",
                               "payer" => {
                                 "payment_method" => "paypal"
                               },
                               "transactions" => [
                                 {
                                   "amount" => {
                                     "total" => total_amount,
                                     "currency" => "USD",
                                     "details" => {
                                       "subtotal" => amount,
                                       "tax" => "0.00",
                                       "shipping" => "0.00",
                                       "handling_fee" => spotswap_fee,
                                       "shipping_discount" => "0.00",
                                       "insurance" => "0.00"
                                     }
                                   },
                                   "description" => "The payment transaction description.",
                                   "custom" => email,
                                   "payment_options" => {
                                     "allowed_payment_method" => "INSTANT_FUNDING_SOURCE"
                                   }
                                 }
                               ],
                               "redirect_urls": {
                                 "return_url": "https://example.com",
                                 "cancel_url": "https://example.com"
                               }
                             })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    return response.body
  end

  def transfer_amount(account_id, payment_id)
    uri = URI.parse("https://api-m.sandbox.paypal.com/v1/payments/payment/#{payment_id}/execute")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{@token}"
    request.body = JSON.dump({
                               "payer_id" => account_id
                             })

    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    return response.body
  end
end