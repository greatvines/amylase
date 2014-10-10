class DropDataSourceGroups < ActiveRecord::Migration
  def up
    drop_table :data_source_groups
    drop_table :data_source_group_associations
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
