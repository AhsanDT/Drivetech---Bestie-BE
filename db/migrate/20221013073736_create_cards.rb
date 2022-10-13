class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.string :token
      t.string :number
      t.string :exp_month
      t.integer :exp_year
      t.integer :cvc
      t.string :brand
      t.string :country
      t.string :card_holder_name
      t.boolean :default, default: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
