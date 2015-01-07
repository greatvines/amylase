class TplGooddataExtract < ActiveRecord::Base
  nilify_blanks

  JOB_SPEC_PERMITTED_ATTRIBUTES =
    [
      :id,
      :gooddata_project_id,
      :destination_credential_id,
      :destination_path
    ]

  belongs_to :gooddata_project
  belongs_to :destination_credential, class_name: 'ExternalCredential'

  has_one :job_spec, as: :job_template

  has_one :client, through: :job_spec


  extend Amylase::JobInitializers
  include Amylase::BirstSoap
  attr_accessor :launched_job

  def run_template
    #TBD
  end

end
