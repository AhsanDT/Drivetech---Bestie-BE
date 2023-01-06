class AddColumnToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :booking_sender_id, :string
  end
end
