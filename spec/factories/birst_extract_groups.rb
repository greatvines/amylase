FactoryGirl.define do
  factory :birst_extract_group do
    sequence(:name) { |n| "MyBirstExtractGroup-#{n}" }
    description "MyText"
  end
end
