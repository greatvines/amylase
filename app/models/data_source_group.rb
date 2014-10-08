class DataSourceGroup < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :data_source_group_associations, dependent: :destroy
  has_many :data_sources, through: :data_source_group_associations

  accepts_nested_attributes_for :data_source_group_associations, allow_destroy: true
end
