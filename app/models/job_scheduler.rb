class JobScheduler
  include ActiveModel::Model
  @@job_scheduler_instance = nil

  attr_accessor :timeout
#  attr_reader :running, :started_at, :uptime, :threads, :job_list

  # Public: Override the ActiveModel initialize method to set the
  # job_scheduler_instance.  This is used by the JobScheduler::new
  # method to determine whether to create a new job_scheduler instance
  # or return the existing one.
  def initialize(*args)
    super

    Rails.logger.warn "JobScheduler instance already exists!" if @@job_scheduler_instance
    @@job_scheduler_instance ||= self
  end

  # Public: Shuts down the Rufus job scheduler and unassigns the single JobScheduler
  # instance allowed.
  #
  # Returns nothing.
  def destroy
    @rufus.shutdown if @rufus
    @@job_scheduler_instance = nil
  end

  # Public: Starts up the Rufus job scheduler.  Schedules a shutdown
  # job if the timeout is set.  TODO: Load all enabled jobs.
  #
  # Returns nothing.
  def start_scheduler
    @rufus = Rufus::Scheduler.new
    schedule_shutdown_job if self.timeout
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

    jobs = []
    @rufus.jobs.each do |job|
      jobs << {
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
      @@job_scheduler_instance
    end
  end


  private

    # Private: Shuts down the Rufus scheduler after a given amount of time
    # has elapsed.  Note that this will not destroy the JobScheduler instance.
    #
    # timeout_interval - The amount of time that will elapse before shutting
    #                    down the Rufus scheduler (default: self.timeout).
    #
    # Returns nothing.
    def schedule_shutdown_job(timeout_interval = self.timeout)
      @rufus.in timeout_interval, :blocking => true, :overlap => false do
        Rails.logger.info "Shutting down scheduler on request."
        @rufus.shutdown
      end
    end

end
