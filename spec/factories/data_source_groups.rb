# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :data_source_group do
    sequence(:name) { |n| "MyDataSourceGroup-#{n}" }
  end
end
