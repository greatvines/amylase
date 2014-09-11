# spec/factories/job_schedul_groups.rb

FactoryGirl.define do
  factory :job_schedule_group do
    sequence(:name) { |n| "MyScheduleGroup-#{n}" }

    trait :in_1s do
      sequence(:name) { |n| "MyScheduleGroupIn1s-#{n}" }

      after(:build) do |job_schedule_group, evaluator|
        job_schedule_group.job_schedules << build_list(:job_schedule, 1, :in_1s, job_schedule_group: job_schedule_group)
      end
    end

    trait :interval_1s do
      sequence(:name) { |n| "MyScheduleGroupInterval1s-#{n}" }

      after(:build) do |job_schedule_group, evaluator|
        job_schedule_group.job_schedules << build_list(:job_schedule, 1, :interval_1s, job_schedule_group: job_schedule_group)
      end
    end

    trait :schedule_maintenance do
      sequence(:name) { |n| "MyScheduleGroupWithMaintenanceSchedules-#{n}" }


      after(:build) do |job_schedule_group, evaluator|
        job_schedule_group.job_schedules << build_list(:job_schedule, 1, :cron_term, job_schedule_group: job_schedule_group)
        job_schedule_group.job_schedules << build_list(:job_schedule, 1, :maintenance_complete, job_schedule_group: job_schedule_group)
        job_schedule_group.job_schedules << build_list(:job_schedule, 1, :cron_start, job_schedule_group: job_schedule_group)
      end
    end
  end


  factory :job_schedule do
    schedule_method "cron"
    schedule_time   "* 01 * * * America/Los_Angeles"
    job_schedule_group

    # The following 3 examples would be used to generate a "maintenance break"
    # A specific cron job terminates at a time, the job then runs once (presumably
    # after the maintenance period is over), then is is scheduled via cron
    # begining after the maintenance period.
    trait :cron_term do
      schedule_method "cron"
      schedule_time   "* 01 * * * America/Los_Angeles"
      last_at        "2014-09-14 20:00:00" # Suppose maintenance period begins at 22:00
    end

    trait :maintenance_complete do
      schedule_method "at"
      schedule_time   "2014-09-15 06:00:00" # Maintenance period ends at 05:00 the next day
    end

    trait :cron_start do
      schedule_method "cron"
      schedule_time   "* 01 * * * America/Los_Angeles"
      first_at        "2014-09-15 06:00:00" # Resume normal scheduling
    end


    # A simple job used to test actual scheduling
    trait :in_1s do
      schedule_method 'in'
      schedule_time   '1s'
    end

    # A simple job used to test actual scheduling
    trait :interval_1s do
      schedule_method 'interval'
      schedule_time   '1s'
    end
  end
end
