class CreatePages < ActiveRecord::Migration[6.1]
  def change
    create_table :pages do |t|
      t.string :title
      t.string :permalink
      t.timestamps
    end

    add_index :pages, :permalink
  end
end
