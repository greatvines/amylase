class CreateGooddataProjects < ActiveRecord::Migration
  def change
    create_table :gooddata_projects do |t|
      t.text :name, :null => false
      t.text :description
      t.text :project_uid
      t.references :client, index: true

      t.timestamps
    end
    
    add_index :gooddata_projects, :name, unique: true
  end
end
