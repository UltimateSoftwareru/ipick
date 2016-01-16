# == Schema Information
#
# Table name: orders
#
#  id                :integer          not null, primary key
#  status            :string           default("opened"), not null
#  name              :string
#  description       :text
#  photo_confirm     :boolean
#  user_id           :integer
#  value             :integer
#  price             :integer
#  weight            :integer
#  from_address_id   :integer
#  delivery_estimate :date
#  grab_from         :datetime
#  grab_to           :datetime
#  deliver_from      :datetime
#  deliver_to        :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

FactoryGirl.define do
  factory :order, class: Order do
    name { |n| "name_#{n}" }
    association :from_address, factory: :address
    after(:create) do |order|
      FactoryGirl.create_list(:addresses, 1, order: order)
    end
  end
end
