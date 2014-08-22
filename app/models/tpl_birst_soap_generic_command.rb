class TplBirstSoapGenericCommand < ActiveRecord::Base
  validates_presence_of :command
  has_one :job_spec, as: :job_template

  accepts_nested_attributes_for :job_spec
end
