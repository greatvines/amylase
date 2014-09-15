class TplBirstSoapGenericCommand < ActiveRecord::Base
  JOB_SPEC_PERMITTED_ATTRIBUTES = [:command, :argument_json]

  validates_presence_of :command
  has_one :job_spec, as: :job_template

  include Amylase::JobHelpers
  include Amylase::BirstSoap

  def run_job(*args)
    result = nil
    Amylase::BirstSoap::Session.new do |bws|
      result = bws.send(command)
    end
    result
  end

end
