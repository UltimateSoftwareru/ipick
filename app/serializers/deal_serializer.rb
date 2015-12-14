class DealSerializer < ActiveModel::Serializer
  attributes :id,
             :status,
             :comment,
             :picture,
             :delivered_at,
             :created_at,
             :updated_at

  belongs_to :order
  belongs_to :courier
end
