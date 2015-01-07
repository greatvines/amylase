class TplGooddataExtract < ActiveRecord::Base
  belongs_to :gooddata_project
  belongs_to :destination_credential
end
