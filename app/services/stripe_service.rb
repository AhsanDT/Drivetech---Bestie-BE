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
    package.update(price: event.data.object.unit_amount, duration: event.data.object.recurring.interval)
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
end
