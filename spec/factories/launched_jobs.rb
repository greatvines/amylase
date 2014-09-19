# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :launched_job do
    # use defaults for everything

    trait :with_tpl_dev_test_job_spec do
      association :job_spec, factory: [:job_spec, :template_tpl_dev_test]
    end

  end
end
