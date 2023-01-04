class AddColumnToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_online, :boolean
  end
end
