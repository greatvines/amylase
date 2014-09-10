# spec/factories/job_specs.rb

FactoryGirl.define do
  factory :job_spec do
    name          "factorygirl_job_spec"
    association :job_template, factory: :tpl_dev_test

    # Other template associations

    trait :tpl_birst_soap_generic_command do
      association :job_template, factory: :tpl_birst_soap_generic_command
    end


    # Schedule associations

    trait :schedule_maintenance do
      association :job_schedule_group, factory: :job_schedule_group_with_schedules
    end
    
    trait :schedule_in_1s do
      association :job_schedule_group, :in_1s
    end

  end

end
