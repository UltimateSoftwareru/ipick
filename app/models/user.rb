class User < ActiveRecord::Base
  establish_connection "iwant_users_#{Rails.env}".to_sym

  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_many :orders, inverse_of: :user
  belongs_to :complainable, polymorphic: true
  has_many :addresses
end

