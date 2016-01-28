class AdditionalFieldsToUser < ActiveRecord::Migration
  class User < ActiveRecord::Base
    establish_connection "iwant_users_#{Rails.env}".to_sym
  end

  def connection
    @connection = User.connection
  end

  def change
    @connection = User.connection

    unless table_exists? :users
      create_table(:users) do |t|
        ## Database authenticatable
        t.string :email,              null: false, default: ""
        t.string :encrypted_password, null: false, default: ""

        ## Recoverable
        t.string   :reset_password_token
        t.datetime :reset_password_sent_at

        ## Rememberable
        t.datetime :remember_created_at

        ## Trackable
        t.integer  :sign_in_count, default: 0, null: false
        t.datetime :current_sign_in_at
        t.datetime :last_sign_in_at
        t.string   :current_sign_in_ip
        t.string   :last_sign_in_ip

        # Confirmable
        t.string   :confirmation_token
        t.datetime :confirmed_at
        t.datetime :confirmation_sent_at
        t.string   :unconfirmed_email

        # Lockable
        t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
        t.string   :unlock_token # Only if unlock strategy is :email or :both
        t.datetime :locked_at

        t.string :provider, :string, null: false, default: "email"
        t.string :uid, :string, null: false, default: ""
        t.text :tokens, :text

        t.timestamps
      end
      add_index :users, :email,                unique: true
      add_index :users, :reset_password_token, unique: true
      add_index :users, :confirmation_token,   unique: true
      add_index :users, :unlock_token,         unique: true
      add_index :users, [:uid, :provider],     unique: true

      User.find_each do |user|
        user.update(uid: SecureRandom.hex(8))
      end
    end

    change_table :users do |t|
      unless column_exists? :users, :type
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
end
