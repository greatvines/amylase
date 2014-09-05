class JobScheduleGroup < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_length_of :name, minimum: 3, maximum: 255

  has_many :job_schedules, dependent: :destroy, inverse_of: :job_schedule_group
  accepts_nested_attributes_for :job_schedules, reject_if: :all_blank, allow_destroy: true

  has_many :job_specs

end
