class CreateDataSourceGroupAssociations < ActiveRecord::Migration
  def change
    create_table :data_source_group_associations do |t|
      t.belongs_to :data_source
      t.belongs_to :data_source_group

      t.timestamps
    end

    add_index :data_source_group_associations, [:data_source_id, :data_source_group_id], unique: true, name: 'idx_data_source_groups_associations'
    add_index :data_source_group_associations, :data_source_group_id
  end
end
