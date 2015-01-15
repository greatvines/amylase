class AddAppendTimestampToTplGooddataExtract < ActiveRecord::Migration
  def change
    add_column :tpl_gooddata_extracts, :append_timestamp, :boolean, default: true
  end
end
