# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :data_source_collection do
    sequence(:name) { |n| "MyDataSourceCollection-#{n}" }
    
    trait :with_existing_sources do
      after(:build) do |data_source_collection, evaluator|
        data_source_collection.data_sources << create_list(:data_source, 2)
        data_source_collection.data_sources << create_list(:data_source, 1, :s3_data_source)
      end
    end

  end
end
