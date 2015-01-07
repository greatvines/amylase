class TplGooddataExtract < ActiveRecord::Base
  nilify_blanks

  JOB_SPEC_PERMITTED_ATTRIBUTES =
    [
      :id,
      :gooddata_project_id,
      :destination_credential_id,
      :destination_path,
      tpl_gooddata_extract_reports_attributes: 
        [
          :id,
          :tpl_gooddata_extract_id,
          :_destroy,
          :name,
          :report_oid,
          :destination_file_name
        ]
    ]

  belongs_to :gooddata_project
  belongs_to :destination_credential, class_name: 'ExternalCredential'

  has_one :job_spec, as: :job_template
  has_one :client, through: :job_spec
  has_many :tpl_gooddata_extract_reports, dependent: :destroy, inverse_of: :tpl_gooddata_extract
  accepts_nested_attributes_for :tpl_gooddata_extract_reports, reject_if: :all_blank, allow_destroy: true


  extend Amylase::JobInitializers
  include Amylase::BirstSoap
  attr_accessor :launched_job

  def run_template
    #TBD
  end

end
