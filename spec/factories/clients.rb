# spec/factories/clients.rb

FactoryGirl.define do
  factory :client do
    sequence(:name) { |n| "MyClient-#{n}" }
    redshift_schema "client__stage"
    salesforce_username "example@greatvines.com"
  end
end
