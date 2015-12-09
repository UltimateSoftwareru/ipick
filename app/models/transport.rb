class Transport < ActiveRecord::Base
  belongs_to :courier
  has_and_belongs_to_many :orders
end
