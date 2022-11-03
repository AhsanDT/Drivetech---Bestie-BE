class AddDefaultToBanks < ActiveRecord::Migration[6.1]
  def change
    add_column :banks, :default, :boolean, default: false
  end
end
