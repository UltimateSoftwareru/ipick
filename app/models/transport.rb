# == Schema Information
#
# Table name: transports
#
#  id   :integer          not null, primary key
#  name :string
#

class Transport < ActiveRecord::Base
  belongs_to :courier, foreign_key: :user_id
  has_and_belongs_to_many :orders
end
