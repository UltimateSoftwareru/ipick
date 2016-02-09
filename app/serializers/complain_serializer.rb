# == Schema Information
#
# Table name: complains
#
#  id         :integer          not null, primary key
#  subject    :string
#  resolution :string
#  status     :string           default("opened"), not null
#  from_type  :string
#  to_type    :string
#  to_id      :integer
#  from_id    :integer
#  user_id    :integer
#  deal_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class ComplainSerializer < ActiveModel::Serializer
  attributes :id, :subject, :resolution, :status

  belongs_to :operator, foreign_key: :user_id
  belongs_to :from, polymorphic: true
  belongs_to :to, polymorphic: true
  belongs_to :order
end
