class AddPackageIdToPackage < ActiveRecord::Migration[6.1]
  def change
    add_column :packages, :package_id, :string
  end
end
