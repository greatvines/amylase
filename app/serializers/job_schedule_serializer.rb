class JobScheduleSerializer < ActiveModel::Serializer
  attributes :id, :schedule_method, :schedule_time, :first_at, :last_at, :number_of_times
end
