class CreateAddress < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :phone
      t.integer :user_id

      # Geocoder
      t.float :latitude
      t.float :longitude
    end
  end
end
