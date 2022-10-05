class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :location
      t.integer :age
      t.string :experience
      t.float :rate
      t.string :country
      t.string :city
      t.string :sex
      t.integer :pronoun
      t.float :latitude
      t.float :longitude
      t.integer :profile_type
      t.timestamps
    end
  end
end
