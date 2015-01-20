FactoryGirl.define do
  factory :gooddata_project do
    sequence(:name) { |n| "MyProject-#{n}" }
    description "MyText"
    project_uid "12345678901234567890123456789012"
    client
  end
end
