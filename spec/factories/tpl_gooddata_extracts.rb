FactoryGirl.define do
  factory :tpl_gooddata_extract do
    gooddata_project nil
    destination_credential nil
    destination_path 'reports/somefile.zip'

    trait :with_job_spec_and_project do
      after(:build) do |tpl_gooddata_extract, evaluator|
        client = build :client
        build :job_spec, job_template: tpl_gooddata_extract, client: client
        build :gooddata_project, client: client
      end
    end

  end
end
