class PayPalConnectAccountService < BaseService

  def initialize
    super
  end

  def retrevie_paypal_customer_account(current_user, account)
    uri = URI.parse("https://api.sandbox.paypal.com/v2/customer/partner-referrals/#{account.account_id}")
    request = Net::HTTP::Get.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{@token}"
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    if response.code  == "200"
      result = JSON.parse(response.body)
      return account_details = {email: current_user.email, account_id: result["links"].first["href"].split("/").last, response: result}
    end
  end

  def create_paypal_customer_account(current_user, email)
    uri = URI.parse("https://api-m.sandbox.paypal.com/v2/customer/partner-referrals")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{@token}"
    request.body = JSON.dump({
                               "tracking_id" => "PAYPAL_CUSTOMER_#{current_user.id}",
                               "operations" => [
                                 {
                                   "operation" => "API_INTEGRATION",
                                   "api_integration_preference" => {
                                     "rest_api_integration" => {
                                       "integration_method" => "PAYPAL",
                                       "integration_type" => "THIRD_PARTY",
                                       "third_party_details" => {
                                         "features" => ["PAYMENT", "REFUND","PARTNER_FEE"]
                                       }
                                     }
                                   }
                                 }
                               ],
                               "products" => ["EXPRESS_CHECKOUT"],
                               "legal_consents" => [
                                 {
                                   "type" => "SHARE_DATA_CONSENT",
                                   "granted" => true
                                 }
                               ],
                               "partner_config_override" => {
                                 "return_url" => "https://example.com",
                                 "return_url_description" => "the url to return the merchant after the paypal onboarding process.",
                                 "action_renewal_url" => "https://example.com",
                                 "show_add_credit_card" => true
                               },
                               "email" => email,
                               "preferred_language_code" => "en-US",
                             })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    if response.code  == "201"
      result = JSON.parse(response.body)
      return account_details = { email: email, response: result }
    end
  end
end