class TplBirstDuplicateSpace < ActiveRecord::Base
  nilify_blanks

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

  validates_format_of :from_space_id_str, 
                      with: /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/, 
                      message: "space id must be a UUID (e.g., 5efddbea-3481-46fd-b7c1-4e04046cefb7)"
 
  after_initialize :defaults, unless: :persisted?

  def defaults
    self.with_membership = true if self.with_membership.blank?
    self.with_data = true if self.with_data.blank?
    self.with_datastore = true if self.with_datastore.blank?
  end

  extend Amylase::JobInitializers
  include Amylase::BirstSoap
  attr_accessor :launched_job

  def run_template

    components_drop = [] +
      (self.with_membership ? [] : ["settings-membership"]) +
      (self.with_data       ? [] : ["data"])                +
      (self.with_datastore  ? [] : ["datastore"])

    launched_job.update(status_message: "Creating new space")
    new_space_id = create_new_space(self.to_space_name, comments = "Duplicated from #{self.from_space_id_str}").result_data

    launched_job.update(status_message: "Replicating space #{self.from_space_id_str}")
    copy_space(
      from_id:         self.from_space_id_str,
      to_id:           new_space_id,
      mode:            "replicate",
      components_drop: components_drop
    )

    # Bug with Birst 5.12 requires that we copy membership again (00065865)
    if self.with_membership

      launched_job.update(status_message: "Replicating membership from #{self.from_space_id_str}")
      copy_space(
        from_id:         self.from_space_id_str,  
        to_id:           new_space_id,
        mode:            "replicate",
        components_keep: ["settings-membership"]
      )

      copy_space(
        from_id:         self.from_space_id_str,
        to_id:           new_space_id,
        mode:            "replicate",
        components_keep: ["settings-permissions"]
      )
    end
  end
end
