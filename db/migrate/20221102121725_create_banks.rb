class CreateBanks < ActiveRecord::Migration[6.1]
  def change
    create_table :banks do |t|
      t.references :user
      t.string :country
      t.string :currency
      t.string :account_holder_name
      t.string :account_holder_type
      t.string :routing_number
      t.string :account_number
      t.string :bank_id

      t.timestamps
    end
  end
end
