# == Schema Information
#
# Table name: orders
#
#  id                :integer          not null, primary key
#  status            :string           default("opened"), not null
#  name              :string
#  description       :text
#  photo_confirm     :boolean
#  user_id           :integer
#  value             :integer
#  price             :integer
#  weight            :integer
#  from_address_id   :integer
#  delivery_estimate :date
#  grab_from         :datetime
#  grab_to           :datetime
#  deliver_from      :datetime
#  deliver_to        :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

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
             :created_at

  belongs_to :person, foreign_key: :user_id
  has_many :deals
  has_many :addresses
  has_many :transports
  belongs_to :from_address
end
