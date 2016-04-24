class Admin < ActiveRecord::Base
  establish_connection "iwant_users_#{Rails.env}".to_sym

  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
end
