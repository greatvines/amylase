class TplGooddataExtractReport < ActiveRecord::Base
  nilify_blanks
  belongs_to :tpl_gooddata_extract

  VALID_EXPORT_METHODS = ['executed', 'raw']

  validates_presence_of(:name)
  validates_presence_of(:report_oid)
  validates_presence_of(:destination_file_name)

  validates_inclusion_of :export_method, in: VALID_EXPORT_METHODS, allow_nil: false

  def run_template
    raise 'TplGooddataExtractReport can only be run in the context of TplGooddataExtract'
  end

end
