class JobSchedule < ActiveRecord::Base
  nilify_blanks

  SCHEDULE_METHODS = %w(cron at interval in)

  belongs_to :job_schedule_group

  validates_presence_of(:job_schedule_group)
  validates_presence_of(:schedule_method)
  validates_presence_of(:schedule_time)

  validates_inclusion_of :schedule_method, in: SCHEDULE_METHODS, message: "Schedule method must be one of #{SCHEDULE_METHODS}"

  validates_each :schedule_time do |record, attr, value|
    unless parses_cron(value) || parses_duration(value) || parses_datetime(value)
      record.errors.add(attr, 'Invalid time format: must be a duration, cron, or datetime yyyy-MM-dd HH:mm:ss [TimeZone]')
    end
  end

  validates_each [:first_at, :last_at], allow_blank: true do |record, attr, value|
    unless parses_datetime(value)
      record.errors.add(attr, 'Datetime must be in format yyyy-MM-dd HH:mm:ss [TimeZone]')
    end
  end

  # Public: Converts JobSchedule attributes into an options hash needed by the
  # Rufus scheduler.
  #
  # Returns: A hash with Rufus options.
  def rufus_options
    opts = {}
    [:first_at, :last_at, :number_of_times].each do |opt|
      opts[opt] = self.send(opt) if self.send(opt).present?
    end

    # rufus gives an error if first_at is in the past, so drop it
    opts.delete(:first_at) if opts[:first_at].present? ? Rufus::Scheduler.parse(opts[:first_at]) < Time.now : false    

    # set a skip flag if last_at is in the past
    if opts[:last_at].present?
      opts[:_skip] = true if Rufus::Scheduler.parse(opts[:last_at]) < Time.now
    end

    opts
  end

  class << self
    def parses_cron(value)
      Rufus::Scheduler.parse_cron(value, {}) rescue nil
    end

    def parses_duration(value)
      Rufus::Scheduler.parse_duration(value, {}) rescue nil
    end

    def parses_datetime(value)
      # Datetime needs to match a specific datetime regex and actually be a valid datetime 
      regex_match = (value =~ /^[0-9]{4}-[0-1][0-9]-[0-3][0-9]\s[0-2][0-9]:[0-5][0-9]:[0-5][0-9]\s*[\w-]*/)
      rufus_parse = lambda { |value| Rufus::Scheduler.parse(value, {}) rescue nil }.call(value)
      regex_match && rufus_parse
    end
  end

end
