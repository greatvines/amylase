class BirstProcessGroupCollectionAssociation < ActiveRecord::Base
  belongs_to :birst_process_group_collection
  belongs_to :birst_process_group
end
