class AddStatusPriorityToLaunchedJobs < ActiveRecord::Migration
  def up
    add_column :launched_jobs, :status_priority, :integer

    LaunchedJob.reset_column_information
    LaunchedJob.all.each do |j|
      j.save
    end
  end

  def down
    drop_column :launched_jobs, :status_priority
  end

end
