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
    # case event.type
    # when 'product.created'
      @package = Package.create(name: event.data.object.name )
    # when 'price.created'
    #   @package = Package.create(price: )
    # end
  end

  def self.create_price(event)
    
  end

  def self.update_package(event)

  end

  def delete_package

  end
end
