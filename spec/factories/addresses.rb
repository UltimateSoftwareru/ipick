FactoryGirl.define do
  factory :address, class: Address do
    name { |n| "name_#{n}" }
  end
end
