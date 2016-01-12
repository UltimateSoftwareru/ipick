# == Schema Information
#
# Table name: deals
#
#  id                   :integer          not null, primary key
#  status               :string           default("in_progress"), not null
#  comment              :text
#  order_id             :integer
#  user_id              :integer
#  interested           :boolean
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  delivered_at         :datetime
#  created_at           :datetime
#  updated_at           :datetime
#

class Deal < ActiveRecord::Base
  belongs_to :order
  belongs_to :courier, foreign_key: :user_id
  has_many :complains

  IN_PROGRESS = :in_progress
  DELIVERED = :delivered
  DECLINED = :declined

  has_attached_file :picture, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  delegate :assign!, :deliver!, :reopen!, :close!, to: :order, prefix: true

  scope :in_status, ->(status = IN_PROGRESS) { where(status: status) }
  scope :declined_by, ->(courier_id) { where(user_id: courier_id, status: DECLINED) }

  after_create :order_assign!, if: :in_progress?

  state_machine :status, initial: :in_progress do
    state :in_progress
    state :delivered
    state :declined

    after_transition :in_progress => :declined, do: :order_reopen!
    after_transition :in_progress => :delivered, do: :order_deliver!

    event :decline do
      transition :in_progress => :declined
    end

    event :deliver do
      transition :in_progress => :delivered
    end
  end
end
