class DefaultPayment < ApplicationRecord
  belongs_to :user

  enum payment_type: {
    card: 0,
    apple_pay: 1,
    paypal: 2
  }
end
