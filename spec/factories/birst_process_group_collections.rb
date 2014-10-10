# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :birst_process_group_collection do
    sequence(:name) { |n| "MyBirstProcessGroupCollection-#{n}" }
    description "A really awesome one"

    trait :with_existing_groups do
      after(:build) do |birst_process_group_collection, evaluator|
        birst_process_group_collection.birst_process_groups << create_list(:birst_process_gorup,3)
      end
    end
  end
end
