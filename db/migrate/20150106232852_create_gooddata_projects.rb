class CreateGooddataProjects < ActiveRecord::Migration
  def change
    create_table :gooddata_projects do |t|
      t.text :name
      t.text :description
      t.text :project_uid
      t.references :client, index: true

      t.timestamps
    end
  end
end
