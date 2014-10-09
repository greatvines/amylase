class CreateDataSourceGroups < ActiveRecord::Migration
  def change
    create_table :data_source_groups do |t|
      t.text :name, :null => false

      t.timestamps
    end

    add_index :data_source_groups, :name, unique: true
  end
end
