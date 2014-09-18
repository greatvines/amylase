class TplDevTest < ActiveRecord::Base
  JOB_SPEC_PERMITTED_ATTRIBUTES = [ :argument ]

  validates_presence_of :argument
  has_one :job_spec, as: :job_template

  extend Amylase::JobInitializers

  # Public: This method is called by the job launcher to do the actual work
  # that the template is designed to perform.
  #
  # job - The LaunchedJob instance that launched this specific job
  #       template instance. This gives the job access to the job log
  #       and allows it to update that status during execution.
  #
  # Returns the job status
  def run_template(job, *args)
    job.update(status_message: "Running TplDevTest job")
    job.job_log.info "Logging within TplDevTest job"

    job.status
  end
end
