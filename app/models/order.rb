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

class Order < ActiveRecord::Base
  belongs_to :person, foreign_key: :user_id
  has_and_belongs_to_many :addresses
  belongs_to :from_address, class_name: :Address
  has_and_belongs_to_many :transports
  has_many :deals, dependent: :destroy
  has_one :assigned_deal, -> { where(status: [Deal::IN_PROGRESS, Deal::DELIVERED]) }, class_name: :Deal

  OPENED = :opened
  ASSIGNED = :assigned
  DELIVERED = :delivered
  CLOSED = :closed

  delegate :courier, :delivered?, to: :assigned_deal, prefix: false

  scope :in_status, ->(status = [OPENED, ASSIGNED]) { where(status: status) }
  #FIXME: use -1 hack due to bug with NOT IN [] operand
  scope :open_for, ->(courier_id) { where("id NOT IN (?)", [-1, *Deal.declined_by(courier_id).pluck(:order_id)]) }

  state_machine :status, initial: OPENED do
    state OPENED
    state ASSIGNED
    state DELIVERED
    state CLOSED

    event :assign do
      transition OPENED => ASSIGNED
    end

    event :deliver do
      transition ASSIGNED => DELIVERED
    end

    event :reopen do
      transition CLOSED => OPENED
    end

    event :close do
      transition OPENED => CLOSED
    end
  end

  def create_deal(status, courier)
    deals.create(status: status, courier: courier)
    assign! if status == Deal::IN_PROGRESS
  end
end
