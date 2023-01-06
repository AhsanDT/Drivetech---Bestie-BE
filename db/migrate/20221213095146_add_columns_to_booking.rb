class AddColumnsToBooking < ActiveRecord::Migration[6.1]
  def change
    add_column :bookings, :start_time, :datetime, default: [], array: true
    add_column :bookings, :end_time, :datetime, default: [], array: true
  end
end
