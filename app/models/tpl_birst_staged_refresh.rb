class TplBirstStagedRefresh < ActiveRecord::Base
  belongs_to :data_source_collection
  belongs_to :process_group_collection
  belongs_to :production_space
  belongs_to :staging_space
end
