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

  def self.create_package(event)
    @package = Package.create(name: event.data.object.name, package_id: event.data.object.id)
  end

  def self.create_price(event)
    package = Package.find_by(package_id: event.data.object.product)
    package.update(price: event.data.object.unit_amount, duration: event.data.object.recurring.interval, price_id: event.data.object.id)
  end

  def self.update_package(event)
    package = Package.find_by(package_id: event.data.object.id)
    package.update(name: event.data.object.name)
  end

  def self.update_price(event)
    package = Package.find_by(package_id: event.data.object.product)
    if package.present?
      package.update(price: event.data.object.unit_amount, duration: event.data.object.recurring.interval)
    end
  end

  def self.delete_package(event)
    package = Package.find_by(package_id: event.data.object.id)
    if package.present?
      package.destroy
    end
  end

  def self.create_bank(customer_id, bank_id)
    data = Stripe::Customer.create_source(customer_id, { source: bank_id })
    return data
  end

  def self.retrive_bank(customer_id, bank_id)
    bank_account = Stripe::Customer.retrieve_source(customer_id, bank_id)
    return bank_account
  end

  def self.create_subscription(customer_id, price_id)
    subscription = Stripe::Subscription.create(customer: customer_id, items: [{price: price_id}])
    return subscription
  end

  def self.retrieve_subscription(subscription_id)
    subscription = Stripe::Subscription.retrieve(subscription_id)
  end

  def self.delete_subscription(subscription_id)
    subscription = Stripe::Subscription.cancel(subscription_id)
  end

  def self.create_charge_by_card(amount, stripe_customer_id)
    charge = Stripe::Charge.create({
      amount: amount,
      currency: 'usd',
      customer: stripe_customer_id
    })
  end

  def self.update_default(stripe_customer_id, token)
    Stripe::Customer.update(
      stripe_customer_id,
      {invoice_settings: {default_payment_method: token}},
    )
  end
end
