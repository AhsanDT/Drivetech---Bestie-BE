class CreateBlockUser < ActiveRecord::Migration[6.1]
  def change
    create_table :block_users do |t|
      t.references :blocked_user
      t.references :blocked_by

      t.timestamps
    end
  end
end
