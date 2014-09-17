class LaunchedJobSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time, :status, :status_message, :result_data, :log_file
  has_one :job_spec
end
