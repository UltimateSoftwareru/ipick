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

  belongs_to :person, foreign_key: :user_id
  has_many :deals
  has_one :assigned_deal
end
