class TplBirstStagedRefreshSerializer < ActiveModel::Serializer
  attributes :id
  has_one :data_source_collection
  has_one :process_group_collection
  has_one :production_space
  has_one :staging_space
end
