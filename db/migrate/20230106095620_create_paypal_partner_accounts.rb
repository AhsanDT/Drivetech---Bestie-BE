class CreatePaypalPartnerAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :paypal_partner_accounts do |t|
      t.integer :payment_type
      t.string :account_id
      t.string :account_type
      t.string :email
      t.boolean :is_default, default: false
      t.references :user

      t.timestamps
    end
  end
end
