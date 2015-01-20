class AddExportMethodToTplGooddataExtractReport < ActiveRecord::Migration
  def change
    add_column :tpl_gooddata_extract_reports, :export_method, :text, null: false
  end
end
