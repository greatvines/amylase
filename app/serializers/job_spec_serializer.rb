class JobSpecSerializer < ActiveModel::Serializer
  attributes :id, :name, :enabled, :job_template_type
  has_one :job_schedule_group
  has_one :job_template, polymorphic: true
end
