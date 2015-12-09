class Deal < ActiveRecord::Base
  belongs_to :order, inverse_of: :deals
  belongs_to :courier
  has_many :complains
end
