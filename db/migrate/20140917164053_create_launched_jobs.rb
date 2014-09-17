class CreateLaunchedJobs < ActiveRecord::Migration
  def change
    create_table :launched_jobs do |t|
      t.belongs_to :job_spec, index: true
      t.timestamp :start_time
      t.timestamp :end_time
      t.text :status
      t.text :status_message
      t.text :result_data
      t.text :log_file

      t.timestamps
    end
  end
end
