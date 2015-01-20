class CreateTplGooddataExtractReports < ActiveRecord::Migration
  def change
    create_table :tpl_gooddata_extract_reports do |t|
      t.text :name, null: false
      t.references :tpl_gooddata_extract, null: false, index: true
      t.text :report_oid, null: false
      t.text :destination_file_name, null: false

      t.timestamps
    end
  end
end
