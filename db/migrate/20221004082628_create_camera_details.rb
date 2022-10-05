class CreateCameraDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :camera_details do |t|
      t.text :talent, default: [], array: true
      t.string :model
      t.integer :camera_type
      t.text :equipment, default: [], array: true
      t.text :others
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
