class GooddataProject < ActiveRecord::Base
  nilify_blanks

  PID_REGEX = /[0-9a-z]{32}/

  belongs_to :client

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_format_of :project_uid, with: PID_REGEX, message: "Gooddata project ids are 32 characters long and consist of only numbers and lowercase letters"
end
