class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :user, foreign_key: true, index:true
      t.references :conversation, foreign_key: true, index: true
      t.boolean :is_read, default: false
      t.timestamps
    end
  end
end
