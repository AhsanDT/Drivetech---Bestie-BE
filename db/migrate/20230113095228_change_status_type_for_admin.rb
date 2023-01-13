class ChangeStatusTypeForAdmin < ActiveRecord::Migration[6.1]
  def change
    change_column :admins, :status,:string
  end
end
