class DataSourceGroupAssociation < ActiveRecord::Base
  belongs_to :data_source_group
  belongs_to :data_source
end
