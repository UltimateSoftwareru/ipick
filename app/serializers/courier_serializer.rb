class CourierSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :type
end
