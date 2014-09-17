class JobSpec < ActiveRecord::Base
  after_initialize :defaults, unless: :persisted?

  job_template_types_prod = %w(TplBirstSoapGenericCommand TplBirstDuplicateSpace)
  job_template_types_test = %w(TplDevTest)
  JOB_TEMPLATE_TYPES = job_template_types_prod if Rails.env.production?
  JOB_TEMPLATE_TYPES = (job_template_types_prod + job_template_types_test).uniq if !Rails.env.production?

  validates_inclusion_of :job_template_type, in: JOB_TEMPLATE_TYPES, allow_nil: false

  validates_uniqueness_of :name
  validates_presence_of :name

  belongs_to :job_template, polymorphic: true, dependent: :destroy, inverse_of: :job_spec
  accepts_nested_attributes_for :job_template, reject_if: :all_blank

  belongs_to :job_schedule_group

  has_many :launched_jobs


  def defaults
    self.enabled = false if self.enabled.nil?
  end

  def run_job(*args)
    self.job_template.run_job(*args)
  end

  def build_job_template(params)
    raise "Unknown job_template_type: #{job_template_type}" unless JOB_TEMPLATE_TYPES.include?(job_template_type)

    klass = job_template_type.constantize
    self.job_template = klass.new(params.select { |param| klass::JOB_SPEC_PERMITTED_ATTRIBUTES.include?(param.to_sym) })
  end
end
