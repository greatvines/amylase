class TplBirstStagedRefresh < ActiveRecord::Base
  belongs_to :data_source_collection
  belongs_to :birst_process_group_collection
  belongs_to :production_space, class_name: 'BirstSpace'
  belongs_to :staging_space, class_name: 'BirstSpace'

  has_one :job_spec, as: :job_template

  has_many :data_sources, through: :data_source_collection
  has_many :birst_process_groups, through: :birst_process_group_collection
  has_one :client, through: :job_spec

  extend Amylase::JobInitializers
  include Amylase::BirstSoap
  attr_accessor :launched_job


  def production_space_or_default
    production_space || self.job_spec.client.birst_spaces.where(space_type: 'production').first
  end

  def staging_space_or_default
    staging_space || self.job_spec.client.birst_spaces.where(space_type: 'staging').first
  end


  def run_template

    staging_space_uuid = self.staging_space_or_default.space_uuid
    production_space_uuid = self.production_space_or_default.space_uuid
    data_source_list = self.data_sources.to_a

    data_source_list.each do |ds| 
      opts = case ds.data_source_type
             when 'RedshiftS3DataSource'
               { redshift_schema: self.client.redshift_schema }
             else
               nil
             end
      ds.initialize_data_source_type(opts)
    end

    delete_all_data(staging_space_uuid)
    upload_data_sources(staging_space_uuid, data_source_list)
    extract_space(staging_space_uuid)
    process_space(staging_space_uuid, process_groups: self.birst_process_groups.collect { |g| g.name })

    copy_space(
      from_id:         production_space_uuid,
      to_id:           staging_space_uuid, 
      mode:            "replicate",
      components_keep: ["catalog",
                        "CustomGeoMaps.xml",
                        "custom-subject-areas", 
                        "dashboardstyles", 
                        "SavedExpressions.xml", 
                        "DrillMaps.xml"
                       ],
      wait_timeout:    "10m"
    )    

    swap_spaces(production_space_uuid, staging_space_uuid)
  end
end
