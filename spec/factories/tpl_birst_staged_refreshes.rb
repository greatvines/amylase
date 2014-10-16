# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tpl_birst_staged_refresh do
    data_source_collection nil
    birst_process_group_collection nil
    production_space nil
    staging_space nil

    trait :with_job_spec do
      after(:build) do |tpl_birst_staged_refresh, evaluator|
        build :job_spec, :with_client_spaces, job_template: tpl_birst_staged_refresh
      end
    end

    trait :with_data_sources do
      association :data_source_collection, :with_existing_sources
    end

  end
end
