class AddFullNameInAdmin < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :full_name,:string
  end
end
