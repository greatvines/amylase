class JobScheduler
  include ActiveModel::Model
  extend ActiveModel::Naming

  @@job_scheduler_instance = nil

  attr_accessor :id, :timeout

  # Public: Override the ActiveModel initialize method to set the
  # job_scheduler_instance.  This is used by the JobScheduler::new
  # method to determine whether to create a new job_scheduler instance
  # or return the existing one.
  def initialize(attributes={})
    super

    @id = 1

    Rails.logger.warn "JobScheduler instance already exists!" if @@job_scheduler_instance
    @@job_scheduler_instance ||= self

    @@job_scheduler_instance.timeout = attributes[:timeout]
  end

  # Public: When rails "creates" the scheduler by saving the object, the
  # scheduler is started.
  #
  # Returns nothing.
  def save!
    start_scheduler
  end

  # Public: Used to mimic functionality not present in non-table models.
  #
  # Returns true if the scheduler was started successfully, false otherwise.
  def save
    begin
      save!
      true
    rescue
      false
    end
  end

  def self.create!(attributes={})
    job_scheduler = self.new(attributes)
    job_scheduler.save!
    job_scheduler
  end

  # Public: Used to mimic functionality not present in non-table models.
  #
  # Returns true.
  def id?
    true
  end

  # Public: Used to mimic functionality not present in non-table models.
  def to_param
    id
  end

  # Public: Shuts down the Rufus job scheduler and unassigns the single JobScheduler
  # instance allowed.
  #
  # Returns nothing.
  def destroy
    shutdown
    @@job_scheduler_instance = nil
  end

  # Public: Shuts down the Rufus job scheduler if it exists.
  #
  # Returns nothing.
  def shutdown(opt=:kill)
    @rufus.shutdown(opt) if @rufus
  end

  # Public: Starts up the Rufus job scheduler.  Schedules a shutdown
  # job if the timeout is set.  Loads all of the schedules of enabled
  # JobSpecs.
  #
  # Returns nothing.
  def start_scheduler
    @rufus = Rufus::Scheduler.new
    schedule_shutdown_job if self.timeout
    schedule_job_specs
  end


  # Public: Reads through all of the schedules of the enabled JobSpecs and 
  # adds them to the Rufus scheduler queue.
  #
  # Returns nothing.
  def schedule_job_specs
    JobSpec.where(enabled: true).each do |job_spec|
      job_schedule_group = job_spec.job_schedule_group
      next unless job_schedule_group

      job_schedule_group.job_schedules.each do |job_schedule|
        job_spec.job_template
        opts = job_schedule.rufus_options
        @rufus.send(job_schedule.schedule_method, job_schedule.schedule_time, JobHandler.new(job_spec), opts)
      end
    end
  end

  # Public: The JobHandler class is used for encapsulating Rufus jobs.  It is
  # used to log the launching and termination of jobs and track status.
  class JobHandler
    
    # Public: Initialize the JobHandler.
    #
    # job_spec - Expects a JobSpec object that contains a complete description of
    #            the job to be executed.
    #
    # Returns nothing.
    def initialize(job_spec)
      @job_spec = job_spec
    end

    attr_reader :job_spec, :status

    # Public: Rufus executes the call method when the job starts.
    #
    # rjob - A Rufus job object that contains various metadata about the status
    #        of a job.
    # time - The time when the job got cleared for triggering.
    #
    # Returns nothing.
    def call(rjob, time)
      Rails.logger.info "Scheduling job #{@job_spec.name} at time #{time}"
      Rails.logger.info JobSpecSerializer.new(@job_spec).as_json.to_yaml unless @job_spec.job_template_type == 'TplSchedulerShutdown'

      begin
        @job_spec.job_template.run_job(@status)
      rescue => err
        Rails.logger.error "Backtrace: #{$!}\n\t#{err.backtrace.join("\n\t")}"
        raise err
      end
    end
  end


  # Public: Execution of the Ruby script will wait until the Rufus job scheduler
  # is shut down.  This is mostly useful for testing.
  #
  # Returns nothing.
  def wait_for_shutdown
    @rufus.join
  end

  # Public: Returns whether the Rufus scheduler is running or not.
  #
  # Returns a boolean.
  def running
    @rufus ? !@rufus.down? : false
  end

  # Public: Returns when the Rufus scheduler was started.
  #
  # Returns a Time.
  def started_at
    @rufus ? @rufus.started_at : nil
  end

  # Public: Returns the amount of time the Rufus scheduler has been running.
  #
  # Returns a string.
  def uptime
    @rufus ? @rufus.uptime : nil
  end

  # Public: Returns the threads that the Rufus scheduler is running on.
  #
  # Returns an array of threads.
  def threads
    @rufus ? @rufus.threads : nil
  end

  # Public: Returns a list of the jobs that are scheduled to run with
  # the Rufus scheduler.  This should mostly be used for debugging and early
  # development.
  #
  # Returns an array of job hashes.
  def job_list
    return nil unless @rufus
    return @saved_job_list if !running

    jobs = []
    @rufus.jobs.each do |job|
      jobs << {
                :name => job.handler.job_spec.name,
                :running => job.running?,
                :last_time => job.last_time,
                :next_time => job.next_time,
                :opts => job.opts,
                :scheduled_at => job.scheduled_at,
                :unscheduled_at => job.unscheduled_at,
                :id => job.id,
                :tags => job.tags,
                :last_work_time => job.last_work_time,
                :mean_work_time => job.mean_work_time
              }
    end
    jobs
  end

  # Public: This is called just prior to shutdown so that the job list
  # can be evaluated after Rufus shuts down (otherwise jobs go away
  # when Rufus is shutdown)
  #
  # Returns the job_list.
  def save_job_list
    @saved_job_list = job_list
  end


  class << self
    # Public: Modify the ::new method to return the job_scheduler_instance
    # determined during #initialize.  This is designed to ensure that
    # only one scheduler instance is created at a time.
    #
    # Returns a JobScheduler instance.
    def new(*args)
      super
      @@job_scheduler_instance
    end

    # Public: Returns the job scheduler instance (if defined).
    #
    # Returns a JobScheduler instance.
    def all
      Array(@@job_scheduler_instance)
    end

    def find(*args)
      @@job_scheduler_instance
    end

  end


  private

    # Private: Struct that mimics a job_template that is used to shutdown the scheduler.
    # There is no reason to allow users to to set this up, so no need for a full MVC.
    TplSchedulerShutdown = Struct.new(:job_scheduler) do
      def run_job(*args)
        job_scheduler.save_job_list
        job_scheduler.shutdown(:kill)
      end
    end
    private_constant :TplSchedulerShutdown

    # Private: Struct that mimics a job_spec that is used to shutdown the scheduler.
    # There is no reason to allow users to to set this up, so no need for a full MVC.
    ShutdownJobSpec = Struct.new(:job_scheduler) do
      def name
        self.class.name
      end

      def job_template_type
        'TplSchedulerShutdown'
      end

      def job_template
        TplSchedulerShutdown.new(job_scheduler)
      end
    end
    private_constant :ShutdownJobSpec



    # Private: Shuts down the Rufus scheduler after a given amount of time
    # has elapsed.  Note that this will not destroy the JobScheduler instance.
    #
    # timeout_interval - The amount of time that will elapse before shutting
    #                    down the Rufus scheduler (default: self.timeout).
    #
    # Returns nothing.
    def schedule_shutdown_job(timeout_interval = self.timeout)
      @rufus.in timeout_interval, JobHandler.new(ShutdownJobSpec.new(self)), :blocking => true, :overlap => false
    end
end

