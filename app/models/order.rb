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
  CLOSED = :closed

  delegate :courier, :delivered?, to: :assigned_deal, prefix: false

  scope :in_status, ->(status = [OPENED, ASSIGNED]) { where(status: status) }
  #FIXME: use -1 hack due to bug with NOT IN [] operand
  scope :open_for, ->(courier_id) { where("id NOT IN (?)", [-1, *Deal.declined_by(courier_id).pluck(:order_id)]) }

  state_machine :status, initial: :opened do
    state :opened
    state :assigned
    state :delivered
    state :closed

    event :assign do
      transition :opened => :assigned
    end

    event :deliver do
      transition :assigned => :delivered
    end

    event :reopen do
      transition :closed => :opened
    end

    event :close do
      transition :opened => :closed
    end
  end

  def create_deal(status, courier)
    deals.create(status: status, courier: courier)
    assign! if status == Deal::IN_PROGRESS
  end
end
