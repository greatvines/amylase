class LaunchedJobDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :link_to, :pretty_print_duration, :row_functions, :format_datetime, :truncate

  # uncomment the appropriate paginator module,
  # depending on gems available in your project.
  include AjaxDatatablesRails::Extensions::Kaminari
  # include AjaxDatatablesRails::Extensions::WillPaginate
  # include AjaxDatatablesRails::Extensions::SimplePaginator

  def sortable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @sortable_columns ||= [
      'launched_jobs.id',
      'clients.name',
      'job_specs.name',
      'launched_jobs.start_time',
      'launched_jobs.run_time',
      'launched_jobs.status_message',
      'launched_jobs.status',
      'launched_jobs.id'
    ]
  end

  def searchable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @searchable_columns ||= [
      'launched_jobs.id',
      'client.name',
      'job_spec.name',
      'launched_job.start_time',
      'launched_job.run_time',
      'launched_job.status_message',
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
        record.id,
        record.job_spec.client.try(:name),
        record.job_spec.name,
        format_datetime(record.start_time),
        pretty_print_duration(record.run_time),
        truncate(record.status_message, length: 30),
        record.status,
        row_functions(record.id)
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
