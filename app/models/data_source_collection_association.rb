class DataSourceCollectionAssociation < ActiveRecord::Base
  belongs_to :data_source_collection
  belongs_to :data_source
end
