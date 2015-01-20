FactoryGirl.define do
  factory :external_credential do
    sequence(:name) { |n| "MyCredential-#{n}" }
    description "MyText"
    username "MyUsername"
    password "ThisShouldBeEncrypted"


    trait :gooddata_admin do
      name 'GooddataAdmin'
      description 'Dummy GooddataAdmin credential'
      username 'coolguy@example.com'
      password 'qwerty'
    end
  end
end
