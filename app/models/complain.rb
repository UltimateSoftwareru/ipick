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
#  created_at :datetime
#  updated_at :datetime
#  order_id   :integer
#  body       :text
#

class Complain < ActiveRecord::Base
  belongs_to :operator, foreign_key: :user_id
  belongs_to :order
  belongs_to :from, polymorphic: true
  belongs_to :to, polymorphic: true

  OPENED = :opened
  RESOLVED = :resolved
  STATUSES = [OPENED, RESOLVED]

  scope :in_status, ->(status = [OPENED]) { where(status: status) }

  state_machine :status, initial: OPENED do
    state OPENED
    state RESOLVED

    event :resolve do
      transition OPENED => RESOLVED
    end
  end
end
