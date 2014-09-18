class TplDevTest < ActiveRecord::Base
  JOB_SPEC_PERMITTED_ATTRIBUTES = [ :argument ]

  validates_presence_of :argument
  has_one :job_spec, as: :job_template

  extend Amylase::JobInitializers
  attr_accessor :launched_job

  # Public: This method is called by the job launcher to do the actual work
  # that the template is designed to perform.
  #
  # Returns the job status
  def run_template
    launched_job.update(status_message: "Running TplDevTest job")
    launched_job.job_log.info "Logging within TplDevTest job"

    launched_job.status
  end
end
