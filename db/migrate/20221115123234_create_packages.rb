class CreatePackages < ActiveRecord::Migration[6.1]
  def change
    create_table :packages do |t|
      t.string :name
      t.float :price
      t.string :duration

      t.timestamps
    end
  end
end
