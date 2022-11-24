class StripeConnectService
  require 'stripe'
  Stripe.api_key= 'sk_test_51LxAJ3DiNzNaLXAEKpYJso4smJZR20YV4OVwlNJ0y2b3jEY0hRDvkqwaQI77gsnB3w6iYE2XFjFfqoulETBKsl1000MCQylqqn'

  def self.create_connect_account(country, email, return_url, user, refresh_url)
    if !user.stripe_connect_id.present?
      connect_account = Stripe::Account.create({
        type: 'express',
        country: country,
        email: email,
        capabilities: {
          card_payments: {requested: true},
          transfers: {requested: true},
        },
        business_type: "individual",
        individual: {
          email: email,
        },
      })

      user.update(stripe_connect_id: connect_account.id)
    end
    
    @link = Stripe::AccountLink.create(
      {
        account: user.stripe_connect_id,
        refresh_url: refresh_url,
        return_url: return_url,
        type: "account_onboarding",
      },
    )

    return @link
  end

  def self.retrieve_account(account_id)
    account = Stripe::Account.retrieve(account_id)
    return account
  end

  def self.login_link(stripe_connect_id)
    link = Stripe::Account.create_login_link(stripe_connect_id)
    return link
  end
end