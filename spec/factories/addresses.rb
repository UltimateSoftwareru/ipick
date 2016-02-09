# == Schema Information
#
# Table name: addresses
#
#  id        :integer          not null, primary key
#  name      :string
#  phone     :string
#  user_id   :integer
#  latitude  :float
#  longitude :float
#  address   :string
#

FactoryGirl.define do
  factory :address, class: Address do
    name { |n| "name_#{n}" }
    latitude 1
    longitude 1
  end
end
