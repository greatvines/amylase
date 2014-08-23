class TplBirstDuplicateSpace < ActiveRecord::Base
  JOB_SPEC_PERMITTED_ATTRIBUTES = 
    [
      :from_space_id_str, 
      :to_space_name, 
      :with_membership, 
      :with_data, 
      :with_datastore
    ]

  validates_presence_of :from_space_id_str, :to_space_name
  has_one :job_spec, as: :job_template

  validates_format_of :from_space_id_str, with: /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
 
  after_initialize :defaults, unless: :persisted?
  
  def defaults
    self.with_membership = true if self.with_membership.nil?
    self.with_data = true if self.with_data.nil?
    self.with_datastore = true if self.with_datastore.nil?
  end
end
