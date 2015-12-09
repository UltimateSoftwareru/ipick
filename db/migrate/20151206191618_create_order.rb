class CreateOrder < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status
      t.string :name
      t.text :description
      t.boolean :photo_confirm
      t.integer :user_id
      t.integer :value
      t.integer :price
      t.integer :weight
      t.date :delivery_estimate
      t.datetime :grab_from
      t.datetime :grab_to
      t.datetime :deliver_from
      t.datetime :deliver_to

      # Geocoder
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
