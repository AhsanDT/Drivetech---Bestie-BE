class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :otp, :integer
    add_column :users, :otp_expiry, :datetime
    add_column :users, :login_type, :string
    add_column :users, :profile_completed, :boolean, default: false
  end
end
