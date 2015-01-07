class CreateTplGooddataExtractReports < ActiveRecord::Migration
  def change
    create_table :tpl_gooddata_extract_reports do |t|
      t.text :name
      t.references :tpl_gooddata_extract, index: true
      t.text :report_oid
      t.text :destination_file_name

      t.timestamps
    end
  end
end
