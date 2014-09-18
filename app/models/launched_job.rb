class LaunchedJob < ActiveRecord::Base
  after_initialize :defaults, unless: :persisted?

  belongs_to :job_spec

  extend Amylase::JobInitializers
  include Amylase::JobLog

  SUCCESS = "success"
  ERROR   = "error"
  RUNNING = "running"
  UNKNOWN = "unknown"

  STATUS_VALUES = [SUCCESS, ERROR, RUNNING, UNKNOWN]

  validates_inclusion_of :status, in: STATUS_VALUES, allow_nil: false


  # Public: Used to get the total run time of the launched job.  If the job is
  # currently running, it will return the difference between the start time and the
  # current time.
  #
  # Returns a time value.
  def run_time
    return nil unless self.start_time
    (self.end_time || Time.now) - self.start_time
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


  private

  # Private: Set defaults for the model.
  def defaults
    self.status ||= UNKNOWN
  end


  # Private: This method is run before the specific run_template method is executed.
  # It is used to intialize any instance variables that may need to be set before
  # running the job.  Any modules included the job template model that need
  # initialization should append the name of the initialization method to 
  # the job template class job_initializers.
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
  def initialize_job
    self.class.job_initializers.each do |job_initializer|
      self.send(job_initializer)
    end

    self.job_spec.job_template.class.job_initializers.each do |job_initializer|
      self.job_spec.job_template.send(job_initializer)
    end
  end

  # Private: Saves launched_job instance and Sets the initial status.
  #
  # Returns the launched_job instance.
  def set_initial_status
    self.update(status: RUNNING, start_time: Time.now)
  end

  # Private: Runs the job specified in the job template.
  #
  # Returns the result of running the job template.
  def run_job_template
    self.job_spec.job_template.run_template(self)
  end

  # Private: Log error message to the log, update the status of the launched job,
  # and re-raise the error.
  #
  # Returns nothing.
  def job_error_handler(err)
    @job_log.error error_message(err)
    self.update(status: ERROR, status_message: error_message(err))
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
    rescue => err
      @job_log.error error_message(err)
      raise err
    ensure
      save_log
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
