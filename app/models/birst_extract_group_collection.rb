class BirstExtractGroupCollection < ActiveRecord::Base
  nilify_blanks

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :birst_extract_group_collection_associations, dependent: :destroy
  has_many :birst_extract_groups, through: :birst_extract_group_collection_associations
end
