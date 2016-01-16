class RemoveOrderGeoFields < ActiveRecord::Migration
  def change
    remove_column :orders, :longitude
    remove_column :orders, :latitude
  end
end
