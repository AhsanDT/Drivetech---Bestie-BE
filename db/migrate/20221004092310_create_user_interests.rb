class CreateUserInterests < ActiveRecord::Migration[6.1]
  def change
    create_table :user_interests do |t|
      t.references :user, foreign_key: true
      t.references :interest, foreign_key: true
      t.timestamps
    end
  end
end
