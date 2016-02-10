# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  tokens                 :text
#  picture_file_name      :string
#  picture_content_type   :string
#  picture_file_size      :integer
#  picture_updated_at     :datetime
#  type                   :string           default("Person"), not null
#  name                   :string
#  nickname               :string
#  phone                  :string
#  status                 :string           default("inactive"), not null
#  transport_id           :integer
#  latitude               :float
#  longitude              :float
#

class Courier < User
  has_many :finished_activities, -> { where.not(finish: nil) }, foreign_key: :user_id, class_name: :Activity
  has_one :current_activity, -> { where(finish: nil) }, foreign_key: :user_id, class_name: :Activity
  belongs_to :transport
  has_many :deals, foreign_key: :user_id
  belongs_to :complainable, polymorphic: true
  has_many :orders, through: :deals, foreign_key: :user_id

  def complains
    Complain.where(from_id: self.id, from_type: self.class.name)
  end

  ACTIVE = :active
  INACTIVE = :inactive
  STATUSES = [ACTIVE, INACTIVE]

  state_machine :status, initial: INACTIVE do
    state ACTIVE
    state INACTIVE

    after_transition ACTIVE => INACTIVE do |courier, _|
      courier.current_activity.finish!
    end

    after_transition INACTIVE => ACTIVE do |courier, _|
      courier.create_current_activity
    end

    event :reactive do
      transition INACTIVE => ACTIVE
    end

    event :disactive do
      transition ACTIVE => INACTIVE
    end
  end
end
