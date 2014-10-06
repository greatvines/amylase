# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client do
    name "MyText"
    redshift_schema "MyText"
    salesforce_username "MyText"
  end
end
