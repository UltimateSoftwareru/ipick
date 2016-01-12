# == Schema Information
#
# Table name: deals
#
#  id                   :integer          not null, primary key
#  status               :string           default("in_progress"), not null
#  comment              :text
#  order_id             :integer
#  user_id              :integer
#  interested           :boolean
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  delivered_at         :datetime
#  created_at           :datetime
#  updated_at           :datetime
#

class DealSerializer < ActiveModel::Serializer
  attributes :id,
             :status,
             :comment,
             :picture,
             :delivered_at,
             :created_at,
             :updated_at

  belongs_to :order
  belongs_to :courier, foreign_key: :user_id
end
