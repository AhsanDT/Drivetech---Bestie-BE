class RemoveColumnFromCameraDetail < ActiveRecord::Migration[6.1]
  def up
    remove_column :camera_details, :talent, :text, default: [], array: true
    remove_column :camera_details, :others, :text
    add_column :camera_details, :others, :text, default: [], array: true
  end
  def down
    add_column :camera_details, :talent, :text, default: [], array: true
    add_column :camera_details, :others, :text
    remove_column :camera_details, :others, :text, default: [], array: true
  end
end
