class AddColumnsToAdmins < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :first_name, :string
    add_column :admins, :last_name, :string
    add_column :admins, :date_of_birth, :string
    add_column :admins, :location, :string
    add_column :admins, :username, :string
    add_column :admins, :phone_number, :string
    add_column :admins, :status, :integer, default: 0
  end
end
