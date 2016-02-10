# == Schema Information
#
# Table name: activities
#
#  id      :integer          not null, primary key
#  user_id :integer
#  minutes :integer
#  start   :datetime
#  finish  :datetime
#

class Activity < ActiveRecord::Base
  belongs_to :courier, foreign_key: :user_id
  before_create :assign_start
  delegate :deals, to: :courier, prefix: false

  def finish!
    minutes = TimeDifference.between(self.start, Time.current).in_minutes.to_i
    self.update(finish: Time.current, minutes: minutes)
  end

  def completed_deals
    self.deals.where("status = (?) AND delivered_at BETWEEN (?) AND (?)",
      Deal::DELIVERED, self.start, self.finish)
  end

  private

  def assign_start
    self.start = Time.current
  end
end
