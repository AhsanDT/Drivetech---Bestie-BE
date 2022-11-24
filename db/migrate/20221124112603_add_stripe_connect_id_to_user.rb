class AddStripeConnectIdToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :stripe_connect_id, :string
  end
end
