class AddJobScheduleGroupRefToJobSpecs < ActiveRecord::Migration
  def change
    add_reference :job_specs, :job_schedule_group, index: true
  end
end
