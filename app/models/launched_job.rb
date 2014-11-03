class LaunchedJob < ActiveRecord::Base
  after_initialize :defaults, unless: :persisted?
  before_save :set_status_priority

  belongs_to :job_spec

  extend Amylase::JobInitializers
  include Amylase::JobLog

  SUCCESS = "success"
  ERROR   = "error"
  RUNNING = "running"
  UNKNOWN = "unknown"

  STATUS_VALUES = [SUCCESS, ERROR, RUNNING, UNKNOWN]

  STATUS_PRIORITY_MAP = {
    SUCCESS => 1,
    ERROR   => 9,
    RUNNING => 5,
    UNKNOWN => 10
  }

  class UnableToKillJobNotRunningError < StandardError; end
  class KilledJobError < StandardError; end
  
  validates_inclusion_of :status, in: STATUS_VALUES, allow_nil: false


  # Public: The status priority is a simple map between the status and an
  # integer used to sort launched jobs by priority.
  def set_status_priority
    self.status_priority = STATUS_PRIORITY_MAP[self.status]
  end

  # Public: Used to get the total run time of the launched job.  If the job is
  # currently running, it will return the difference between the start time and the
  # current time.
  #
  # Returns a time value.
  def run_time
    return nil unless self.start_time
    (self.end_time || Time.now) - self.start_time
  end

  # Public: This method allows the LaunchedJob class to act as a job handler
  # for the Rufus scheduler.  At present it is just a wrapper for run_job,
  # but it may be worthwhile to make some information stored in rjob available
  # to the launched_job.
  #
  # rjob - A Rufus job object that contains various metadata about the status
  #        of a job.
  # time - The time when the job got cleared for triggering.
  #
  # Returns nothing.
  def call(rjob, time)
    # Since Rufus scheduler starts a new thread for each job, we must manage the connection
    # pool ourselves.
    # http://stackoverflow.com/questions/11248808/connection-pool-issue-with-activerecord-objects-in-rufus-scheduler
    ActiveRecord::Base.connection_pool.with_connection do
      run_job
    end
  end

  def job_spec_id
    self.job_spec.id
  end

  def job_spec_name
    self.job_spec.name
  end

  # Public: This is the method that is called when the job is to be
  # executed.  It wraps the run_template job that is defined in and
  # specific to individual job template models.
  #
  # Returns nothing.
  def run_job
    begin
      initialize_job
      set_initial_status
      run_job_template
    rescue => err
      job_error_handler(err)
    ensure
      close_job
    end
  end


  # Public: This method is used to kill a job.  It first stops the thread
  # from executing in the JobScheduler and then it closes out the launched
  # job as it would if it exited normally.
  #
  # Returns nothing.
  def kill_job
    raise UnableToKillJobNotRunningError unless self.status == RUNNING
    begin
      JobScheduler.find.try(:kill_job, self)
      raise KilledJobError.new 'Job Killed'
    rescue => err
      job_error_handler(err)
    ensure
      close_job               
    end
  end
  

  private

  # Private: Set defaults for the model.
  def defaults
    self.status ||= UNKNOWN
  end


  # Private: This method is run before the specific run_template
  # method is executed.  It is used to intialize any instance
  # variables that may need to be set before running the job (at
  # either the launched_job or job_template level).
  #
  # Returns nothing.
  def initialize_job
    launched_job_initializers
    job_template_initializers
  end

  # Private: Initializes any modules defined at the launched_job level.
  # Any modules included in the LaunchedJob that need initialization should
  # append the name of the initialization method to the job_initializers
  # class variable.
  #
  # Examples
  #
  #   module JobLog
  #     def self.included(klass)
  #       klass.job_initializers << :initialize_job_log
  #     end
  #   end
  def launched_job_initializers
    self.class.job_initializers.each do |job_initializer|
      self.send(job_initializer)
    end
  end


  # Private: Associates the job template instance with this launched_job instance.
  # Initializes any modules defined at the job template level.  Any modules
  # included in the job template that need initialization should append the
  # name of the initialization method to tje job_initializers class variable.
  #
  # Examples
  #
  #   module BirstSoap
  #     def self.included(klass)
  #       klass.job_initializers << :initialize_birst_soap
  #     end
  #   end
  #
  # Returns nothing.
  def job_template_initializers
    job_template = self.job_spec.job_template
    job_template.launched_job = self

    job_template.class.job_initializers.each do |job_initializer|
      job_template.send(job_initializer)
    end
  end

  # Private: Saves launched_job instance and Sets the initial status.
  #
  # Returns the launched_job instance.
  def set_initial_status
    if LaunchedJob.where(job_spec: self.job_spec, status: LaunchedJob::RUNNING).size > 0
      self.update(status: ERROR, start_time: Time.now)
      raise "JobSpec already running" 
    else
      self.update(status: RUNNING, start_time: Time.now)
    end
  end

  # Private: Runs the job specified in the job template.
  #
  # Returns the result of running the job template.
  def run_job_template
    self.job_spec.job_template.run_template
  end

  # Private: Log error message to the log, update the status of the launched job,
  # and re-raise the error.
  #
  # Returns nothing.
  def job_error_handler(err)
    self.update(status: ERROR, status_message: error_message(err))
    @job_log.error error_message(err)
    raise err
  end

  # Private: Defined the format of the error message.
  #
  # Returns a string with the error message.
  def error_message(err)
    "Backtrace: #{err.class.name}: #{$!}\n\t#{err.backtrace.join("\n\t")}"
  end

  # Private: Performs any tasks needed to close the job, whether it was successful or not.
  # Currently, this is just to set the final status of the job and save the logs.
  #
  # Returns nothing.
  def close_job
    begin
      set_close_status
      self.update(log_file: @job_log_s3_full_path)
    rescue => err
      @job_log.error error_message(err)
      raise err
    ensure
      close_job_log
    end

    nil
  end

  # Private: Sets the status of the job on completion.
  #
  # Returns the launched_job instance.
  def set_close_status
    case self.status
    when RUNNING
      self.update(status: SUCCESS, status_message: "Completed successfully", end_time: Time.now)
    when UNKNOWN
      self.update(status: ERROR, status_message: "UNKNOWN job terminated", end_time: Time.now)
    else
      self.update(end_time: Time.now)
    end
  end

end
