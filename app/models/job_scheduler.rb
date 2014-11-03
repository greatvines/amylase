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

  # Public: Saves a new instance of the job_scheduler with the given attributes.
  #
  # Returns the created instance of the job_scheduler.
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
    schedule_shutdown_job if !self.timeout.blank?
    schedule_job_specs(JobSpec.where(enabled: true))
  end


  # Public: Reads through all of the given job specs and passes them
  # off to be scheduled via JobScheduler#schedule_job_spec.
  #
  # jobs_specs - A collection of JobSpec instances to be scheduled.
  #
  # Returns nothing.
  def schedule_job_specs(job_specs)
    job_specs.each { |job_spec| schedule_job_spec(job_spec) }
  end

  # Public: Adds the specified JobSpec instance to the scheduler.
  #
  # job_spec - A JobSpec instance.
  #
  # Returns nothing.
  def schedule_job_spec(job_spec)
    job_schedule_group = job_spec.job_schedule_group
    return unless job_schedule_group

    job_schedule_group.job_schedules.each do |job_schedule|
      job_spec.job_template
      opts = job_schedule.rufus_options

      opts.delete(:first_at) if opts[:first_at] ? opts[:first_at] < Time.now : false
      return if opts[:last_at] ? opts[:last_at] < Time.now : false

      @rufus.send(job_schedule.schedule_method, job_schedule.schedule_time, LaunchedJob.new(job_spec: job_spec), opts)
    end
  end

  # Public: Schedules a specified JobSpec to run immediately.  Will raise
  # an error if the JobSpec is already running.
  #
  # job_spec - A JobSpec instance.
  #
  # Returns nothing.
  def schedule_job_spec_now(job_spec)
    raise "JobSpec already running" if LaunchedJob.where(job_spec: job_spec, status: LaunchedJob::RUNNING).size > 0
    @rufus.send('in', '0s', LaunchedJob.new(job_spec: job_spec))
  end


  # Public: Unschedules a collection of JobSpecs.  Can also be used to uschedule
  # a single JobSpec instance.  unschedule_job_spec is an alias for this method.
  #
  # job_specs - A collection of or a single instance of a JobSpec(s)
  #
  # Returns nothing.
  def unschedule_job_specs(job_specs)
    job_spec_ids = Array(job_specs).collect { |j| j.id }
    @rufus.jobs.select { |job| Array(job_spec_ids).include? job.handler.job_spec_id }.each(&:unschedule)
  end
  alias_method :unschedule_job_spec, :unschedule_job_specs


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
  alias_method :running?, :running

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

  # Public: Translates the list of Rufus jobs that are scheduled into a hash
  # of job attributes.
  #
  # Returns an array of hashes.
  def jobs
    return nil unless @rufus
    return @saved_job_list if !running

    @rufus.jobs.collect do |job|
      {
        :job => job,
        :job_spec_id => job.handler.job_spec_id,
        :job_spec_name => job.handler.job_spec_name,
        :launched_job => job.handler,
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
  end


  def kill_job(launched_job)
    self.jobs.select { |job| job[:launched_job].id == launched_job.id }.first[:job].kill
  end

  # Public: This is called just prior to shutdown so that the job list
  # can be evaluated after Rufus shuts down (otherwise jobs go away
  # when Rufus is shutdown)
  #
  # Returns the job_list.
  def save_job_list
    @saved_job_list = jobs
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

    # Private: This is a special instance of the LaunchedJob class that is used
    # for the Rufus job handler for the timeout job.
    class SchedulerTimeoutHandler < LaunchedJob
      def run_job
        JobScheduler.find.save_job_list
        JobScheduler.find.shutdown(:kill)
      end

      def job_spec_name
        'SchedulerTimeout'
      end

      def job_spec_id
        -1
      end
    end

    # Private: Shuts down the Rufus scheduler after a given amount of time
    # has elapsed.  Note that this will not destroy the JobScheduler instance.
    #
    # timeout_interval - The amount of time that will elapse before shutting
    #                    down the Rufus scheduler (default: self.timeout).
    #
    # Returns nothing.
    def schedule_shutdown_job(timeout_interval = self.timeout)
      puts "Scheduling the shutdown job"
      @rufus.in timeout_interval, SchedulerTimeoutHandler.new, :blocking => true, :overlap => false
    end
end

