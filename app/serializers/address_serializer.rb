# == Schema Information
#
# Table name: addresses
#
#  id        :integer          not null, primary key
#  name      :string
#  phone     :string
#  user_id   :integer
#  latitude  :float
#  longitude :float
#  address   :string
#

class AddressSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :address

  belongs_to :person
  has_many :orders
end
