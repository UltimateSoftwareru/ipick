class Deal < ActiveRecord::Base
  belongs_to :order
  belongs_to :courier
  has_many :complains

  INTERESTED = :interested
  IN_PROGRESS = :in_progress
  DELIVERED = :delivered
  DECLINED = :declined
  NOT_RELEVANT = :not_relevant

  has_attached_file :picture, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  delegate :opened?, :assign!, :reopen!, :close!, to: :order, prefix: true

  scope :in_status, ->(status = [INTERESTED, IN_PROGRESS]) { where(status: status) }

  state_machine :status, initial: :interested do
    state :interested
    state :in_progress
    state :delivered
    state :declined
    state :not_relevant

    after_transition :interested => :in_progress, do: :order_assign!
    after_transition :in_progress => :declined, do: :order_reopen!
    after_transition :in_progress => :delivered, do: :order_close!

    event :interesting do
      transition any => :interested, if: :order_opened?
    end

    event :accept do
      transition [:declined, :interested] => :in_progress, if: :order_opened?
    end

    event :decline do
      transition [:interested, :in_progress] => :declined
    end

    event :deliver do
      transition :in_progress => :delivered
    end

    event :lose_relevance do
      transition [:interested, :in_progress] => :not_relevant
    end
  end
end
