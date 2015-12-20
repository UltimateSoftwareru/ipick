class AdditionalFieldsToUser < ActiveRecord::Migration
  class User < ActiveRecord::Base
    establish_connection "iwant_users_#{Rails.env}".to_sym
  end

  def connection
    @connection = User.connection
  end

  def change
    @connection = User.connection
    change_table :users do |t|
      ## STI
      t.string :type, null: false, default: "Person"

      ## User Info
      t.string :name
      t.string :nickname
      t.string :phone

      ## Courier info
      t.integer :status
      t.integer :transport_id

      ## Geocoder
      t.float :latitude
      t.float :longitude
    end
  end
end
