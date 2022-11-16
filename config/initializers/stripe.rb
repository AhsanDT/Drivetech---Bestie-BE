Rails.configuration.stripe = {
  :secret_key => ENV["SECRET_KEY"],
  :publishable_key => ENV["PUBLISHABLE_KEY"]
}

StripeEvent.signing_secret = ENV['STRIPE_SIGNING_SECRET']

StripeEvent.configure do |events|
  events.all do |event|
    case event.type
    when 'product.created'
      StripeService.create_package(event)
    when 'price.created'
      StripeService.create_price(event)
    when 'product.updated'
      StripeService.update_package(event)
    when 'price.updated'
      StripeService.update_price(event)
    when 'product.deleted'
      StripeService.delete_package(event)
    end
  end
end