class DeviseTokenAuthCreateCouriers < ActiveRecord::Migration
  def change
    create_table(:couriers) do |t|
      ## Required
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""

      ## Database authenticatable
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      ## User Info
      t.string :name
      t.string :nickname
      t.string :email
      t.attachment :picture
      t.integer :transport_id
      t.integer :status
      t.string :phone

      # Geocoder
      t.float :latitude
      t.float :longitude

      ## Tokens
      t.json :tokens

      t.timestamps
    end

    add_index :couriers, :email
    add_index :couriers, [:uid, :provider],     :unique => true
    add_index :couriers, :reset_password_token, :unique => true
    add_index :couriers, :confirmation_token,   :unique => true
  end
end
