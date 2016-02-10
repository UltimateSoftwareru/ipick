# == Schema Information
#
# Table name: activities
#
#  id      :integer          not null, primary key
#  user_id :integer
#  minutes :integer
#  start   :datetime
#  finish  :datetime
#

class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :minutes, :start, :finish

  belongs_to :courier, foreign_key: :user_id
  has_many :completed_deals
end
