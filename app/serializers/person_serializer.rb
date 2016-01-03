class PersonSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :type

  has_many :orders, foreign_key: :user_id
  has_many :addresses
end
