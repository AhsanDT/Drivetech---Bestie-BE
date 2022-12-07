class ApplePayService
  def self.apple_pay(price)
    intent = Stripe::PaymentIntent.create({
      amount: price,
      currency: "usd",
    })
  end
end