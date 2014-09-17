class LaunchedJob < ActiveRecord::Base
  after_initialize :defaults, unless: :persisted?

  belongs_to :job_spec

  SUCCESS = "success"
  ERROR   = "error"
  RUNNING = "running"
  UNKNOWN = "unknown"

  STATUS_VALUES = [SUCCESS, ERROR, RUNNING, UNKNOWN]

  validates_inclusion_of :status, in: STATUS_VALUES, allow_nil: false

  def defaults
    self.status ||= UNKNOWN
  end

  def run_time
    return nil unless self.start_time
    (self.end_time || Time.now) - self.start_time
  end

  def launch_job
    self.update(status: RUNNING, start_time: Time.now)
    self.job_spec.job_template.run_job(self)
    self
  end

  def terminate_job
    if [RUNNING, UNKNOWN].include? self.status
      self.update(status: ERROR, end_time: Time.now, 
        status_message: ["#{self.status} job terminated", self.status_message].join('|')
      )
    else
      self.update(end_time: Time.now)
    end
    self
  end
end
