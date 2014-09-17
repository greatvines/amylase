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
end
