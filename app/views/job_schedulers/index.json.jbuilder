json.array!(@job_schedulers) do |job_scheduler|
  json.extract! job_scheduler, :id, :down, :started_at, :uptime, :threads, :job_list
  json.url job_scheduler_url(job_scheduler, format: :json)
end
