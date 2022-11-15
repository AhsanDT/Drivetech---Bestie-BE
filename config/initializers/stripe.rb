Rails.configuration.stripe = {
  :secret_key => ENV["SECRET_KEY"],
  :publishable_key => ENV["PUBLISHABLE_KEY"]
}

StripeEvent.signing_secret = ENV['STRIPE_SIGNING_SECRET']

StripeEvent.configure do |event|
  event.subscribe 'product.updated' do |event|
  end
  # event.subscribe 'product.deleted'
  # event.subscribe 'product.updated'
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