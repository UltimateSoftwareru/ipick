class Activity < ActiveRecord::Base
  belongs_to :courier, foreign_key: :user_id
end
