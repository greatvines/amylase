# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :birst_space do
    sequence(:name) { |n| "MySpace-#{n}" }
    space_uuid '00000000-0000-0000-0000-000000000000'
    client
  end
end
