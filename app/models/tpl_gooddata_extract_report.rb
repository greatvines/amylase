class TplGooddataExtractReport < ActiveRecord::Base
  nilify_blanks
  belongs_to :tpl_gooddata_extract

  validates_presence_of(:name)
  validates_presence_of(:report_oid)
  validates_presence_of(:destination_file_name)

  def run_template
    raise 'TplGooddataExtractReport can only be run in the context of TplGooddataExtract'
  end

end
