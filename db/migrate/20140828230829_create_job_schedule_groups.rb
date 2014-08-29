class CreateJobScheduleGroups < ActiveRecord::Migration
  def change
    create_table :job_schedule_groups do |t|
      t.string :name, :limit => 255, :null => false

      t.timestamps
    end

    add_index :job_schedule_groups, :name, unique: true

  end
end
