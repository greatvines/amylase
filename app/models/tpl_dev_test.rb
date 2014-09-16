class TplDevTest < ActiveRecord::Base
  JOB_SPEC_PERMITTED_ATTRIBUTES = [ :argument ]

  validates_presence_of :argument
  has_one :job_spec, as: :job_template

  extend Amylase::TemplateHelpers
  include Amylase::JobHelpers

  def run_template(*args)
    result = true
  end
end
