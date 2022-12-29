class StripePaymentService
  require 'stripe'
  Stripe.api_key= 'sk_test_51LxAJ3DiNzNaLXAEKpYJso4smJZR20YV4OVwlNJ0y2b3jEY0hRDvkqwaQI77gsnB3w6iYE2XFjFfqoulETBKsl1000MCQylqqn'

  def self.create_charge(amount, source, stripe_connect_id)
    charge = Stripe::Charge.create({
      amount: amount,
      currency: "usd",
      source: source,
      transfer_data: {
        destination: stripe_connect_id,
      }
    })
  end

  def self.create_transfer(amount, destination_connect_id)
    transfer = Stripe::Transfer.create({
      amount: amount,
      currency: 'usd',
      destination: destination_connect_id
    })
  end
end