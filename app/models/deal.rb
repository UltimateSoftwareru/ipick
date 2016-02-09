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

  IN_PROGRESS = :in_progress
  DELIVERED = :delivered
  DECLINED = :declined
  STATUSES = [IN_PROGRESS, DELIVERED, DECLINED]

  has_attached_file :picture, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  delegate :assign!, :deliver!, :reopen!, :close!, to: :order, prefix: true

  scope :in_status, ->(status = IN_PROGRESS) { where(status: status) }
  scope :declined_by, ->(courier_id) { where(user_id: courier_id, status: DECLINED) }

  after_create :order_assign!, if: :in_progress?

  state_machine :status, initial: IN_PROGRESS do
    state IN_PROGRESS
    state DELIVERED
    state DECLINED

    after_transition IN_PROGRESS => DECLINED, do: :order_reopen!
    after_transition IN_PROGRESS => DELIVERED, do: :order_deliver!

    event :decline do
      transition IN_PROGRESS => DECLINED
    end

    event :deliver do
      transition IN_PROGRESS => DELIVERED
    end
  end

  def delivered_now!
    self.update(delivered_at: Time.current)
  end
end
