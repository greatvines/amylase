class TplDevTest < ActiveRecord::Base
  JOB_SPEC_PERMITTED_ATTRIBUTES = [ :argument ]

  validates_presence_of :argument
  has_one :job_spec, as: :job_template
end
