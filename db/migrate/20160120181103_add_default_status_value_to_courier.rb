class AddDefaultStatusValueToCourier < ActiveRecord::Migration
  class User < ActiveRecord::Base
    establish_connection "iwant_users_#{Rails.env}".to_sym
  end

  def connection
    @connection = User.connection
  end

  def change
    @connection = User.connection
    change_column :users, :status, :string, null: false, default: "inactive"
  end
end
