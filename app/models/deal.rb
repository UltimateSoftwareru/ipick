class Deal < ActiveRecord::Base
  belongs_to :order, inverse_of: :deals
  belongs_to :courier
  has_many :complains
  IN_PROGRESS = :in_progress

  delegate :opened?, :assign!, :reopen!, :close!, to: :order, prefix: true

  state_machine :status, initial: :interested do
    state :interested
    state :in_progress
    state :delivered
    state :declined

    after_transition :interested => :in_progress, :do => :assign_order!
    after_transition :in_progress => :declined, :do => :reopen_order!
    after_transition :in_progress => :delivered, :do => :close_order!

    event :accept do
      transition :interested => :in_progress, if: :order_opened?
    end

    event :decline do
      transition [:interested, :in_progress] => :declined
    end

    event :deliver do
      transition :in_progress => :delivered
    end
  end
end
