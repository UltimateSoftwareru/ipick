# == Schema Information
#
# Table name: transports
#
#  id   :integer          not null, primary key
#  name :string
#

class TransportSerializer < ActiveModel::Serializer
  attributes :id, :name
end
