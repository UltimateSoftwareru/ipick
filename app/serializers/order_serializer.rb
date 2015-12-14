class OrderSerializer < ActiveModel::Serializer
  attributes :id,
             :status,
             :name,
             :description,
             :photo_confirm,
             :value,
             :price,
             :weight,
             :delivery_estimate,
             :grab_from,
             :grab_to,
             :deliver_from,
             :deliver_to,
             :latitude,
             :longitude,
             :created_at

  belongs_to :user
  has_many :deals
  has_one :assigned_deal
end
