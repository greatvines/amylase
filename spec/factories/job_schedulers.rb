# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :job_scheduler do
    down false
    started_at "2014-09-08 13:16:17"
    uptime "MyString"
    threads "MyString"
    job_list "MyString"
  end
end
