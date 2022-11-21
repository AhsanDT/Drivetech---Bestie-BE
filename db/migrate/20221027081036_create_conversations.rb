class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.integer :sender_id, index: :true, foreign_key: {to_table: :users}
      t.integer :recipient_id, index: :true, foreign_key: {to_table: :users}
      t.integer :unread_messages, default: 0
      t.boolean :is_blocked, default: false
      t.integer :blocked_by
      t.timestamps
    end
  end
end
