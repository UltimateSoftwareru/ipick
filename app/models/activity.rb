# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  data        :date
#  user_id     :integer
#  hours       :integer
#  deals_count :integer
#

class Activity < ActiveRecord::Base
  belongs_to :courier, foreign_key: :user_id
end
