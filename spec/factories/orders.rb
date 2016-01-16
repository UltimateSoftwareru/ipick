FactoryGirl.define do
  factory :order, class: Order do
    name { |n| "name_#{n}" }
    association :from_address, factory: :address
    after(:create) do |order|
      FactoryGirl.create_list(:addresses, 1, order: order)
    end
  end
end
