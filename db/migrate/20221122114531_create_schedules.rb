class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.text :month, default: [], array: true
      t.text :day, default: [], array: true
      t.string :start_time
      t.string :end_time
      t.references :user, foreign_key: true
      
      t.timestamps
    end
  end
end
