class Complain < ActiveRecord::Base
  belongs_to :operator, inverse_of: :comlains
  belongs_to :deal
  belongs_to :from, as: :complainable
  belongs_to :to, as: :complainable
end
