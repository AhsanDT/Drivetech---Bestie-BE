class CreateRecentUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :recent_users do |t|
      t.references :user
      t.references :recent_user

      t.timestamps
    end
  end
end
