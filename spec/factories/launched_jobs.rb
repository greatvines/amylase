# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :launched_job do
    job_spec nil
    start_time "2014-09-17 09:40:53"
    end_time "2014-09-17 09:40:53"
    status "MyString"
    status_message "MyString"
    result_data "MyString"
    log_file "MyString"
  end
end
