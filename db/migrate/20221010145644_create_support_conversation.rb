class CreateSupportConversation < ActiveRecord::Migration[6.1]
  def change
    create_table :support_conversations do |t|
      t.references :support, foreign_key: true
      t.integer :recipient_id
      t.integer :sender_id
      t.timestamps
    end
  end
end
