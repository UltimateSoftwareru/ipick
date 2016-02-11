class AddPictureToUser < ActiveRecord::Migration
  class User < ActiveRecord::Base
    establish_connection "iwant_users_#{Rails.env}".to_sym
  end

  def connection
    @connection = User.connection
  end

  def up
    @connection = User.connection
    unless column_exists? :users, :picture_content_type
      add_attachment :users, :picture
    end
  end

  def down
    @connection = User.connection

    remove_attachment :users, :picture
  end
end
