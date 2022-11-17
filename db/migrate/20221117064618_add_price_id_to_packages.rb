class AddPriceIdToPackages < ActiveRecord::Migration[6.1]
  def change
    add_column :packages, :price_id, :string
  end
end
