class CreateJobSchedules < ActiveRecord::Migration
  def change
    create_table   :job_schedules do |t|
      t.belongs_to :job_schedule_group
      t.string     :schedule_method, :limit => 20
      t.string     :schedule_time, :limit => 80
      t.string     :first_at, :limit => 80
      t.string     :last_at, :limit => 80
      t.integer    :number_of_times

      t.timestamps
    end

    add_index :job_schedules, :job_schedule_group_id

  end
end
