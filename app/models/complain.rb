class Complain < ActiveRecord::Base
  belongs_to :operator, foreign_key: :user_id
  belongs_to :deal
  belongs_to :from, as: :complainable
  belongs_to :to, as: :complainable
end
