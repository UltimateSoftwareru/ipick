class Order < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :addresses
  has_and_belongs_to_many :transports
  has_many :deals
  has_one :assigned_deal, -> { where(status: Deal::IN_PROGRESS) }, class_name: :Deal
  has_one :courier, through: :assigned_deal

  state_machine :status, initial: :opened do
    state :opened
    state :assigned
    state :closed

    event :assign do
      transition :opened => :assigned
    end

    event :reopen do
      transition :assigned => :opened
    end

    event :close do
      transition [:opened, :assigned] => :closed
    end
  end
end
