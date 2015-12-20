class Order < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :addresses
  has_and_belongs_to_many :transports
  has_many :deals, dependent: :destroy
  has_one :assigned_deal, -> { where(status: [Deal::IN_PROGRESS, Deal::DELIVERED]) }, class_name: :Deal
  has_one :courier, through: :assigned_deal

  OPENED = :opened
  ASSIGNED = :assigned
  CLOSED = :closed

  delegate :delivered?, to: :assigned_deal, prefix: false

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
