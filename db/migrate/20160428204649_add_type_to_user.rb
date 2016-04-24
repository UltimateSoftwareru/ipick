class AddTypeToUser < ActiveRecord::Migration
  class User < ActiveRecord::Base
    establish_connection "iwant_users_#{Rails.env}".to_sym
  end

  def connection
    @connection = User.connection
  end

  def change
    @connection = User.connection
    unless column_exists?(:users, :type)
      add_column :users, :type, :string
    end
  end
end
