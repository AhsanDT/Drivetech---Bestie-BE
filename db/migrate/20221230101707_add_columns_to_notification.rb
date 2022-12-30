class AddColumnsToNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :notification_type, :string
    add_reference :notifications, :send_by, index: true
  end
end
