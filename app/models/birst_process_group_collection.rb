class BirstProcessGroupCollection < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :birst_process_group_collection_associations, dependent: :destroy
  has_many :birst_process_groups, through: :birst_process_group_collection_associations
end
