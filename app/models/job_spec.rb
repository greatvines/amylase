class JobSpec < ActiveRecord::Base
  nilify_blanks

  job_template_types_prod = %w(TplBirstSoapGenericCommand TplBirstDuplicateSpace TplBirstStagedRefresh TplGooddataExtract)
  job_template_types_test = %w(TplDevTest)
  JOB_TEMPLATE_TYPES = job_template_types_prod if Rails.env.production?
  JOB_TEMPLATE_TYPES = (job_template_types_prod + job_template_types_test).uniq if !Rails.env.production?

  validates_inclusion_of :job_template_type, in: JOB_TEMPLATE_TYPES, allow_nil: false

  validates_uniqueness_of :name
  validates_presence_of :name

  belongs_to :job_template, polymorphic: true, dependent: :destroy, inverse_of: :job_spec
  accepts_nested_attributes_for :job_template

  belongs_to :job_schedule_group
  belongs_to :client

  has_many :launched_jobs


  # Public: This is a callback that allows us to use accepts_nested_attributes_for
  # with a polymorphic association.  
  # http://stackoverflow.com/questions/3969025/accepts-nested-attributes-for-with-belongs-to-polymorphic
  def build_job_template(params)
    raise "Unknown job_template_type: #{job_template_type}" unless JOB_TEMPLATE_TYPES.include?(job_template_type)

    klass = job_template_type.constantize
    self.job_template = klass.new(params)
  end
end
