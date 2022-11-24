class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.time :start_time, default: [], array: true
      t.time :end_time, default: [], array: true
      t.float :rate
      t.string :location
      t.text :camera_type, default: [], array: true
      t.text :description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
