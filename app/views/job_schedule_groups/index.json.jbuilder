json.array!(@job_schedule_groups) do |job_schedule_group|
  json.extract! job_schedule_group, :id, :name
  json.url job_schedule_group_url(job_schedule_group, format: :json)
end
