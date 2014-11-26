# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :birst_extract_group_collection do
    sequence(:name) { |n| "MyBirstExtractGroupCollection-#{n}" }
    description "A really awesome one"

    trait :with_existing_groups do
      after(:build) do |birst_extract_group_collection, evaluator|
        birst_extract_group_collection.birst_extract_groups << create_list(:birst_extract_group,3)
      end
    end
  end
end
