# == Schema Information
#
# Table name: addresses
#
#  id            :integer          not null, primary key
#  name          :string
#  phone         :string
#  user_id       :integer
#  latitude      :float
#  longitude     :float
#  address       :string
#  short_address :string
#

class AddressSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :address, :short_address, :name, :phone
end
