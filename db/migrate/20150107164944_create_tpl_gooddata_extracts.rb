class CreateTplGooddataExtracts < ActiveRecord::Migration
  def change
    create_table :tpl_gooddata_extracts do |t|
      t.references :gooddata_project, index: true
      t.references :destination_credential, index: true
      t.text :destination_path

      t.timestamps
    end
  end
end
