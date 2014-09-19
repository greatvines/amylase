json.array!(@job_schedules) do |job_schedule|
  json.extract! job_schedule, :id, :schedule_method, :schedule_time, :first_at, :last_at
  json.url job_schedule_url(job_schedule, format: :json)
end
