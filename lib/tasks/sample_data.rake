namespace :sample_data do
  desc "Generate launched jobs data"
  task launched_jobs: :environment do

    FactoryGirl.create_list(:client, 3).each do |client|
      job_spec = FactoryGirl.create(:job_spec, client: client)

      # A few running jobs for each client that started earlier today
      1.upto(3).each do |iter|
        start_time = Time.now - Random.rand(2.hours)
        FactoryGirl.create(:launched_job, job_spec: job_spec, status: LaunchedJob::RUNNING, start_time: start_time)
      end

      # A single error job that started earlier in the day
      start_time = Time.now - 5.hours + Random.rand(1.hour)
      end_time = start_time + Random.rand(1.hour)
      FactoryGirl.create(:launched_job, job_spec: job_spec, status: LaunchedJob::ERROR, start_time: start_time, end_time: end_time)

      # Numerous successfull jobs over the last two weeks
      1.upto(100).each do |iter|
        start_time = Time.now - 1.day - Random.rand(2.weeks)
        end_time = start_time + 1.hour + Random.rand(30.minutes)
        FactoryGirl.create(:launched_job, job_spec: job_spec, status: LaunchedJob::SUCCESS, start_time: start_time, end_time: end_time)
      end
    end
  end
end
