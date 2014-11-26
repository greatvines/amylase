class BirstExtractGroupCollectionAssociation < ActiveRecord::Base
  nilify_blanks

  belongs_to :birst_extract_group_collection
  belongs_to :birst_extract_group
end
