class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true
      t.references :package, foreign_key: true
      t.string :subscription_id 

      t.timestamps
    end
  end
end
