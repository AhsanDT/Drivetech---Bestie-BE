class StripeService
  require 'stripe'
  Stripe.api_key= 'sk_test_51LxAJ3DiNzNaLXAEKpYJso4smJZR20YV4OVwlNJ0y2b3jEY0hRDvkqwaQI77gsnB3w6iYE2XFjFfqoulETBKsl1000MCQylqqn'
  def self.create_customer(name, email)
    response = Stripe::Customer.create({name: name, email: email})
    return response
  end

  def self.create_card(customer_id, token)
    card = Stripe::Customer.create_source(customer_id, {source: token})
    return card
  end

  def self.create_bank(customer_id, bank_id)
    data = Stripe::Customer.create_source(customer_id, { source: bank_id })
    return data
  end

  def self.retrive_bank(customer_id, bank_id)
    bank_account = Stripe::Customer.retrieve_source(customer_id, bank_id)
    return bank_account
  end
end
