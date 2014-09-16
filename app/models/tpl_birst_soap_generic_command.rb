class TplBirstSoapGenericCommand < ActiveRecord::Base
  JOB_SPEC_PERMITTED_ATTRIBUTES = [:command, :argument_json]

  validates_presence_of :command
  has_one :job_spec, as: :job_template

  include Amylase::JobHelpers
  include Amylase::BirstSoap

  def run_template(*args)
    result = nil
    birst_soap_session do |bws|
      result = bws.send(command)
    end
    result
  end

end
