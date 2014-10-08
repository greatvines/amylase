class CreateDataSourceGroups < ActiveRecord::Migration
  def change
    create_table :data_source_groups do |t|
      t.text :name

      t.timestamps
    end
  end
end
