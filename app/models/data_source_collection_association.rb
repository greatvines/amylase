class DataSourceCollectionAssociation < ActiveRecord::Base
  nilify_blanks

  belongs_to :data_source_collection
  belongs_to :data_source
end
