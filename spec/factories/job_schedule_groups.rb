# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :job_schedule_group do
    name "MyScheduleGroup"

    factory :job_schedule_group_with_schedules do
      after(:create) do |job_schedule_group, evaluator|
        create_list(:job_schedule, 1, :cron_term, job_schedule_group: job_schedule_group)
        create_list(:job_schedule, 1, :mantenance_complete, job_schedule_group: job_schedule_group)
        create_list(:job_schedule, 1, :cron_start, job_schedule_group: job_schedule_group)
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

    trait :mantenance_complete do
      schedule_method "at"
      schedule_time   "2014-09-15 06:00:00" # Maintenance period ends at 05:00 the next day
    end

    trait :cron_start do
      schedule_method "cron"
      schedule_time   "* 01 * * * America/Los_Angeles"
      first_at        "2014-09-15 06:00:00" # Resume normal scheduling
    end
  end
end
