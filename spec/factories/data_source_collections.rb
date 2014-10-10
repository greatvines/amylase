# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :data_source_collection do
    sequence(:name) { |n| "MyDataSourceCollection-#{n}" }
    
    trait :with_existing_sources do
      after(:build) do |data_source_collection, evaluator|
        data_source_collection.data_sources << create_list(:data_source,3)
      end
    end

  end
end
