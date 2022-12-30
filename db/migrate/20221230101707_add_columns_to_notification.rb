class AddColumnsToNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :notification_type, :string
    add_reference :notifications, :send_by, index: true
    add_column :notifications, :send_by_name, :string
  end
end
