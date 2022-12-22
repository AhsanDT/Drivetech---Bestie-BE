class AddAdminTypeInAdmin < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :admin_type, :integer, default: 1
  end
end
