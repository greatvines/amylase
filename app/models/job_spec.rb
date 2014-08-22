class JobSpec < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name

  belongs_to :job_template, polymorphic: true, dependent: :destroy
  accepts_nested_attributes_for :job_template, reject_if: :all_blank

  after_initialize :defaults, unless: :persisted?
  
  def defaults
    self.enabled = false if self.enabled.nil?
  end
end
