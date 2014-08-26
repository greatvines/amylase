class JobSpec < ActiveRecord::Base
  JOB_TEMPLATE_TYPES = %w(TplBirstSoapGenericCommand TplBirstDuplicateSpace)
  validates_inclusion_of :job_template_type, in: JOB_TEMPLATE_TYPES, allow_nil: false

  validates_uniqueness_of :name
  validates_presence_of :name

  belongs_to :job_template, polymorphic: true, dependent: :destroy
  accepts_nested_attributes_for :job_template, reject_if: :all_blank

  after_initialize :defaults, unless: :persisted?
  
  def defaults
    self.enabled = false if self.enabled.nil?
  end


  def build_job_template(params)
    raise "Unknown job_template_type: #{job_template_type}" unless JOB_TEMPLATE_TYPES.include?(job_template_type)

    klass = job_template_type.constantize
    self.job_template = klass.new(params.select { |param| klass::JOB_SPEC_PERMITTED_ATTRIBUTES.include?(param.to_sym) })
  end
end
