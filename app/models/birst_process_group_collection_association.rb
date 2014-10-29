class BirstProcessGroupCollectionAssociation < ActiveRecord::Base
  nilify_blanks

  belongs_to :birst_process_group_collection
  belongs_to :birst_process_group
end
