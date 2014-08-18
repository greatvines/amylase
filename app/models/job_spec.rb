class JobSpec < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name

  belongs_to :job_template, polymorphic: true, dependent: :destroy

  after_initialize :defaults, unless: :persisted?
  
  def defaults
    self.enabled = false if self.enabled.nil?
  end
end
