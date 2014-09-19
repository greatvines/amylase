class TplBirstSoapGenericCommand < ActiveRecord::Base
  JOB_SPEC_PERMITTED_ATTRIBUTES = [:command, :argument_json]

  validates_presence_of :command
  has_one :job_spec, as: :job_template

  extend Amylase::JobInitializers
  include Amylase::BirstSoap
  attr_accessor :launched_job

  def run_template
    birst_soap_session do |bws|
      result = bws.send(command)
      launched_job.result_data = (JSON.pretty_generate result rescue result)
    end
  end
end
