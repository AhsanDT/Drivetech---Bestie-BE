Rails.configuration.stripe = {
  :secret_key => ENV["SECRET_KEY"],
  :publishable_key => ENV["PUBLISHABLE_KEY"]
}

StripeEvent.signing_secret = ENV['STRIPE_SIGNING_SECRET']

# Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.configure do |event|
  debugger
  # events.subscribe 'charge.failed' do |event|
  #   # Define subscriber behavior based on the event object
  #   event.class       #=> Stripe::Event
  #   event.type        #=> "charge.failed"
  #   event.data.object #=> #<Stripe::Charge:0x3fcb34c115f8>
  # end

  # events.all do |event|
  #   "product.created",
  #   "product.deleted",
  #   "product.updated"
  #   # Handle all event types - logging, etc.
  # end

  # events.subscribe 'product.created', Stripe::EventHandler.new
  # events.subscribe 'product.deleted', Stripe::EventHandler.new
  # events.subscribe 'product.updated', Stripe::EventHandler.new
end