json.array!(@launched_jobs) do |launched_job|
  json.extract! launched_job, :id, :job_spec_id, :start_time, :end_time, :status, :status_message, :result_data, :log_file
  json.url launched_job_url(launched_job, format: :json)
end
