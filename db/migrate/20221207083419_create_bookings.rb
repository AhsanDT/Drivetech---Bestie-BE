class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.float :rate
      t.references :send_to
      t.references :send_by
      t.integer :status

      t.timestamps
    end
  end
end
