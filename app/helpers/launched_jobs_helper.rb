module LaunchedJobsHelper
  def pretty_print_duration(seconds)
    return '0s' unless seconds
    Rufus::Scheduler.to_duration(seconds.floor)
  end

  def format_datetime(time)
    time.strftime "%Y-%m-%d %H:%M:%S %Z"
  end

  def link_to_log(launched_job_id)
    <<-EOF.unindent
    <div class="hint">
    #{
      link_to job_log_path(launched_job_id), :target => '_blank', :title => 'Download Log', :data => { :toggle => 'tooltip' } do
        raw '<span class="glyphicon glyphicon-download"></span>'
      end
    }
    </div>
    EOF
  end

end
