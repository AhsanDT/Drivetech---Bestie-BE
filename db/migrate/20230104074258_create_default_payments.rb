class CreateDefaultPayments < ActiveRecord::Migration[6.1]
  def change
    create_table :default_payments do |t|
      t.integer :payment_type
      t.references :user
      
      t.timestamps
    end
  end
end
