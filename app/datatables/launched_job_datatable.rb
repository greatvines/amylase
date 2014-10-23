class LaunchedJobDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :link_to, :pretty_print_duration, :link_to_log, :format_datetime

  # uncomment the appropriate paginator module,
  # depending on gems available in your project.
  include AjaxDatatablesRails::Extensions::Kaminari
  # include AjaxDatatablesRails::Extensions::WillPaginate
  # include AjaxDatatablesRails::Extensions::SimplePaginator

  def sortable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @sortable_columns ||= [
      'clients.name',
      'job_specs.name',
      'job_specs.job_template_type',
      'launched_jobs.start_time',
      'launched_jobs.run_time',
      'launched_jobs.status',
      'launched_jobs.id'
    ]
  end

  def searchable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @searchable_columns ||= [
      'client.name',
      'job_spec.name',
      'job_spec.job_template_type',
      'launched_job.start_time',
      'launched_job.run_time',
      'launched_job.status',
      'launched_job.id'
    ]
  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        record.job_spec.client.name,
        record.job_spec.name,
        record.job_spec.job_template_type,
        format_datetime(record.start_time),
        pretty_print_duration(record.run_time),
        record.status,
        link_to_log(record.id)
      ]
    end
  end

  def min_start_date
    @min_start_date ||= options[:min_start_date] || '1900-01-01'
  end

  def get_raw_records
    # insert query here
    LaunchedJob.where('start_time >= ?', min_start_date)
      .includes({ job_spec: :client })
      .references(:job_spec)
      .order(status_priority: :desc, start_time: :desc)

  end

  # ==== Insert 'presenter'-like methods below if necessary
end
