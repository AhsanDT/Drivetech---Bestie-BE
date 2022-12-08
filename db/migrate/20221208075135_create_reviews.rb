class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :description
      t.references :review_by
      t.references :review_to
      t.references :booking
      t.string :type

      t.timestamps
    end
  end
end
