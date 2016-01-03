class AddressSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :address

  belongs_to :person
  has_many :orders
end
