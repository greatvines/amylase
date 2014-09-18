class TplBirstSoapGenericCommand < ActiveRecord::Base
  JOB_SPEC_PERMITTED_ATTRIBUTES = [:command, :argument_json]

  validates_presence_of :command
  has_one :job_spec, as: :job_template

  extend Amylase::JobInitializers
  include Amylase::BirstSoap
  attr_accessor :launched_job

  def run_template
    result = nil
    birst_soap_session do |bws|
      result = bws.send(command)
    end
    result
  end

end
