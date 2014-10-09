# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :birst_process_group do
    sequence(:name) { |n| "MyBirstProcessGroup-#{n}" }
    description "MyDescription"
  end
end
