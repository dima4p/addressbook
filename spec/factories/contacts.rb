# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact do
    sequence(:first_name) { |n| "first_name_#{n}" }
    sequence(:middle_name) { |n| "middle_name_#{n}" }
    sequence(:last_name) { |n| "last_name_#{n}" }
    sequence(:phone) { |n| "phone_#{n}" }
  end
end
