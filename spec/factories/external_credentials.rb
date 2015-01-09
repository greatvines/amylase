FactoryGirl.define do
  factory :external_credential do
    sequence(:name) { |n| "MyCredential-#{n}" }
    description "MyText"
    username "MyUsername"
    password "ThisShouldBeEncrypted"
  end
end
