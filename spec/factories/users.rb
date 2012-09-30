# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@abook.ru" }
    password "password"
    password_confirmation "password"
    sequence(:single_access_token) {|n| "single_access_token_#{n}_string"}
    sequence(:perishable_token) {|n| "perishable_token_#{n}_string"}
  end
end
