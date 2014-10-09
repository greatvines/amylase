# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :data_source_group do
    sequence(:name) { |n| "MyDataSourceGroup-#{n}" }
    
    trait :with_existing_sources do
      after(:build) do |data_source_group, evaluator|
        data_source_group.data_sources << create_list(:data_source,3)
      end
    end

  end
end
