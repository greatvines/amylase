class TplBirstSoapGenericCommand < ActiveRecord::Base
  validates_presence_of :command
  has_one :job_spec, as: :job_template
end
