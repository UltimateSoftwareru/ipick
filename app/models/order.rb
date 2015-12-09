class Order < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :addresses
  has_and_belongs_to_many :transports
  has_many :deals
end
