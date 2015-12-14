class Order < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :addresses
  has_and_belongs_to_many :transports
  has_many :deals, dependent: :destroy
  has_one :assigned_deal, -> { where(status: [Deal::IN_PROGRESS, Deal::DELIVERED]) }, class_name: :Deal
  has_many :active_deals, -> { where(status: [Deal::INTERESTED, Deal::IN_PROGRESS]) }, class_name: :Deal
  has_one :courier, through: :assigned_deal

  OPENED = :opened
  ASSIGNED = :assigned
  CLOSED = :closed

  delegate :delivered?, to: :assigned_deal, prefix: false

  after_create :create_deals!

  scope :in_status, ->(status = [OPENED, ASSIGNED]) { where(status: status) }

  state_machine :status, initial: :opened do
    state :opened
    state :assigned
    state :closed

    after_transition [:opened, :assigned] => :closed, do: :interested_deals_lost_relevance!
    after_transition :closed => :opened, do: :re_interest_deals!

    event :assign do
      transition :opened => :assigned
    end

    event :reopen do
      transition [:assigned, :closed] => :opened
    end

    event :close do
      transition [:opened, :assigned] => :closed
    end
  end

  private

  def create_deals!
    Courier.find_each do |courier|
      deals.create(courier_id: courier.id)
    end
  end

  def interested_deals_lost_relevance!
    active_deals.find_each do |deal|
      deal.lose_relevance!
    end
  end

  def re_interest_deals!
    deals.find_each do |deal|
      deal.interesting!
    end
  end
end
