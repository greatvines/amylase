class JobScheduleGroupSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :job_schedules
end
