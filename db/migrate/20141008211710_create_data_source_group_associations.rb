class CreateDataSourceGroupAssociations < ActiveRecord::Migration
  def change
    create_table :data_source_group_associations do |t|

      t.timestamps
    end
  end
end
