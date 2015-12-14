class User < ActiveRecord::Base
  include Devisable

  establish_connection "iwant_users_#{Rails.env}".to_sym

  has_many :orders, inverse_of: :user
  has_many :deals, through: :orders
  belongs_to :complainable, polymorphic: true
  has_many :addresses
end

