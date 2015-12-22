class Address < ActiveRecord::Base
  belongs_to :person, foreign_key: :user_id
  has_and_belongs_to_many :orders
end
