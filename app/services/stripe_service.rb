class StripeService
  require 'stripe'
  Stripe.api_key= 'sk_test_51LNBEfKFQ4LqmPpIp89IBkHxXiSefWs86PYy9yjSxbrWZXY1LV6erybSawJqW20omGzA5WcGWWNeY6GhLRwEEFCL00A9FLQeVa'
  def self.create_customer(name, email)
    response = Stripe::Customer.create({name: name, email: email})
    return response
  end

  def self.create_card(customer_id, token)
    card = Stripe::Customer.create_source(customer_id, {source: token})
    return card
  end
end
