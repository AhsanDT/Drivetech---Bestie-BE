class BaseService

  require 'net/http'
  require 'uri'
  require 'json'
  CLIENT_ID = "AZ17E3USJ8Iew4FP-0GjFOj9bsO4vQ-ysWZYghpi2_Gq_-gZ7vu4nNh62uBHHBQUVmlEP_QMwx-Mk25_"
  CLIENT_SECRET = "EKCrzmilad8rpEojD8Q6Vec0BbSpMEtD1DKFVH_a75ROgjbzWNnK7dkpCxy0C_c5yFVvOyJaYSVz5GMj"

  def initialize
    uri = URI.parse("https://api-m.sandbox.paypal.com/v1/oauth2/token")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(CLIENT_ID, CLIENT_SECRET)
    request.content_type = "application/x-www-form-urlencoded"
    request.set_form_data(
      "grant_type" => "client_credentials",
      )
    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    if response.code == "200"
      result = JSON.parse(response.body)
      @token =  result["access_token"]
    end
  end
end