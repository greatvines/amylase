module LaunchedJobsHelper
  def pretty_print_duration(seconds)
    return '0s' unless seconds
    Rufus::Scheduler.to_duration(seconds.floor)
  end
end
