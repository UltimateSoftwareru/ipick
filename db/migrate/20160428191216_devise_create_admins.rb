class DeviseCreateAdmins < ActiveRecord::Migration
  class Admin < ActiveRecord::Base
    establish_connection "iwant_users_#{Rails.env}".to_sym
  end

  def connection
    @connection = Admin.connection
  end

  def change
    @connection = Admin.connection

    unless table_exists?(:admins)
      create_table(:admins) do |t|
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
        t.inet     :current_sign_in_ip
        t.inet     :last_sign_in_ip

        t.timestamps null: false
      end

      add_index :admins, :email,                unique: true
      add_index :admins, :reset_password_token, unique: true
    end
  end
end
