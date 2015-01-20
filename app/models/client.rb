class Client < ActiveRecord::Base
  nilify_blanks

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :birst_spaces
  has_many :gooddata_projects
end
