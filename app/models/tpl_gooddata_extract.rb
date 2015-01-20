class TplGooddataExtract < ActiveRecord::Base
  nilify_blanks

  JOB_SPEC_PERMITTED_ATTRIBUTES =
    [
      :id,
      :gooddata_project_id,
      :destination_credential_id,
      :destination_path,
      :append_timestamp,
      tpl_gooddata_extract_reports_attributes:
        [
          :id,
          :tpl_gooddata_extract_id,
          :_destroy,
          :name,
          :report_oid,
          :destination_file_name,
          :export_method
        ]
    ]

  belongs_to :gooddata_project
  belongs_to :destination_credential, class_name: 'ExternalCredential'

  has_one :job_spec, as: :job_template
  has_one :client, through: :job_spec
  has_many :tpl_gooddata_extract_reports, dependent: :destroy, inverse_of: :tpl_gooddata_extract
  accepts_nested_attributes_for :tpl_gooddata_extract_reports, reject_if: :all_blank, allow_destroy: true

  DESTINATION_PATH_REGEX = /(\.zip\Z|\.ZIP\Z|\/\Z)/
  validates_format_of :destination_path, with: DESTINATION_PATH_REGEX, message: 'Destination must either be a *.zip file or a folder (ending in a forward slash - /)'

  extend Amylase::JobInitializers
  attr_accessor :launched_job

  def run_template
    launched_job.update(status_message: 'logging in to Gooddata')
    conn = establish_gooddata_connection

    launched_job.update(status_message: 'exporting files')
    exported_files = export_reports(conn)

    launched_job.update(status_message: 'collecting exported files')
    files_to_send = collect_reports(exported_files)

    launched_job.update(status_message: 'transferring files to ftp')
    transfer_reports_to_ftp(files_to_send)
  end

  def job_log
    @job_log ||= self.launched_job.job_log
  end

  def destination_container
    case
    when zip_container?
      :zip
    when folder_container?
      :folder
    else
      raise "Unknown destination container for #{self.destination_path}"
    end
  end

  def zip_container?
    Pathname(self.destination_path).extname.downcase == '.zip'
  end

  def folder_container?
    self.destination_path.last == '/'
  end

  def zip_name
    zip_container? ? Pathname(self.destination_path).basename.to_s : ''
  end

  def destination_host
    URI(self.destination_path).host
  end

  def destination_scheme
    URI(self.destination_path).scheme
  end

  def destination_folder
    File.join('/',URI(self.destination_path).path).gsub(/#{zip_name}\Z/,'')
  end

  def with_timestamp(path)
    ext = Pathname(path).extname.to_s
    return path if ext.blank? or !self.append_timestamp

    path.gsub(/#{ext}\Z/,"-#{Time.now.utc.strftime('%Y%m%d_%H%M%S')}#{ext}")
  end

  private

  def get_rest_credentials
    credentials = ExternalCredential.where(name: 'GooddataAdmin').take
    raise 'GooddataAdmin rest credential not found' unless credentials
    credentials
  end

  def establish_gooddata_connection
    credentials = get_rest_credentials
    Amylase::GooddataRest.new(
        username: credentials.username,
        password: credentials.password,
        rest_log: self.launched_job.job_log
    )
  end

  def export_reports(conn)
    exported_files = {}
    self.tpl_gooddata_extract_reports.each do |rpt|
      job_log.info "Exporting report #{rpt.name} to #{rpt.destination_file_name}"
      launched_job.update(status_message: "exporting #{rpt.destination_file_name}")
      exported_files[rpt.destination_file_name] = Tempfile.new(rpt.destination_file_name)
      conn.export_report(method: rpt.export_method.to_sym, pid: self.gooddata_project.project_uid, obj: rpt.report_oid, local_file_name: exported_files[rpt.destination_file_name])
    end
    exported_files
  end

  def collect_reports(exported_files)
    return exported_files unless zip_container?

    job_log.info "Zipping reports to #{self.zip_name}"
    zip_tempfile = Tempfile.new(self.zip_name)

    Zip::File.open(zip_tempfile.path, Zip::File::CREATE) do |zipfile|
      exported_files.each do |dest, source|
        zipfile.add(dest, source)
      end
    end

    { self.zip_name => zip_tempfile }
  end

  def transfer_reports_to_ftp(files_hash)
    job_log.info "Connecting to FTP host #{self.destination_host} with username #{self.destination_credential.username}"
    Net::FTP.open(self.destination_host) do |ftp|
      ftp.login(self.destination_credential.username, self.destination_credential.password)
      ftp.passive

      job_log.info "chdir #{self.destination_folder}"
      ftp.chdir(self.destination_folder)

      files_hash.each do |remote_file, local_file|
        job_log.info "putbinaryfile #{Pathname(local_file)} as #{with_timestamp(remote_file)}"
        ftp.putbinaryfile(local_file, with_timestamp(remote_file))
      end
    end
  end

end
