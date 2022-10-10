class CreateSupportMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :support_messages do |t|
      t.text :body
      t.integer :sender_id
      t.references :support_conversation, foreign_key: true
      t.timestamps
    end
  end
end
