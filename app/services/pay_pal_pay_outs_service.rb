class PayPalPayOutsService < BaseService

  def initialize
    super
  end

  def create_payout(dest_email, amount= 10.00)
    uri = URI.parse("https://api-m.sandbox.paypal.com/v1/payments/payouts")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{@token}"
    request.body = JSON.dump({
                               "sender_batch_header" => {
                                 "sender_batch_id" => "PAYOUTS_#{create_batch_id}",
                                 "recipient_type" => "EMAIL",
                                 "email_subject" => "You have money!",
                                 "email_message" => "You received a payment. Thanks for using our service!"
                               },
                               "payment_options" => {
                                 "allowed_payment_method" => "INSTANT_FUNDING_SOURCE"
                               },
                               "items" => [
                                 {
                                   "amount" => {
                                     "value" => amount,
                                     "currency" => "USD"
                                   },
                                   "sender_item_id" => "201403140002",
                                   "recipient_wallet" => "PAYPAL",
                                   "receiver" => dest_email
                                 }
                               ]
                             })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    return response.body
  end

  def create_batch_id
    SecureRandom.hex(10)
  end

end