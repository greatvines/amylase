class TplDevTest < ActiveRecord::Base
  nilify_blanks

  JOB_SPEC_PERMITTED_ATTRIBUTES = [ :id, :argument ]
  
  validates_presence_of :argument
  has_one :job_spec, as: :job_template

  extend Amylase::JobInitializers
  attr_accessor :launched_job

  # The sleep_seconds class instancevariable is used for testing.
  # Any time it is set, it should be unset at the end of
  # the test.
  DEFAULT_SLEEP = 0

  class << self
    attr_accessor :sleep_seconds
    def sleep_seconds
      @sleep_seconds || DEFAULT_SLEEP
    end
  end
  
  # Public: This method is called by the job launcher to do the actual work
  # that the template is designed to perform.
  #
  # Returns the job status
  def run_template
    launched_job.update(status_message: "Running TplDevTest job")
    launched_job.job_log.info "Logging within TplDevTest job"

    sleep self.class.sleep_seconds

    launched_job.status
  end
end
