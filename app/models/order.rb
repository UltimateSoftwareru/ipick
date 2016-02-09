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
  has_many :complains

  after_commit :notify_agents!

  OPENED = :opened
  ASSIGNED = :assigned
  DELIVERED = :delivered
  CLOSED = :closed
  STATUSES = [OPENED, ASSIGNED, DELIVERED, CLOSED]

  delegate :courier, :delivered_now!, :delivered_at, to: :assigned_deal, prefix: false, allow_nil: true

  scope :in_status, ->(status = [OPENED, ASSIGNED]) { where(status: status) }
  #FIXME: use -1 hack due to bug with NOT IN [] operand
  scope :open_for, ->(courier_id) { where("id NOT IN (?)", [-1, *Deal.declined_by(courier_id).pluck(:order_id)]) }
  default_scope { includes(:person, :deals, :transports, :addresses, :from_address) }

  state_machine :status, initial: OPENED do
    state OPENED
    state ASSIGNED
    state DELIVERED
    state CLOSED

    after_transition ASSIGNED => DELIVERED do |order|
      order.delivered_now!
    end

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

  private

  def notify_agents!
    options = { includes: [:person, :from_address, :addresses, :transports, :deals] }
    order = ActiveModel::SerializableResource.new(self, options)

    order_json = order.as_json
    ActionCable.server.broadcast OrdersNotificationChannel.channel_name, order_json
  end
end
