class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :subject
      t.text :body
      t.boolean :is_read, default: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
