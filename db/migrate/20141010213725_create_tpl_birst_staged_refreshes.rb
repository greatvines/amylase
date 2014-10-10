class CreateTplBirstStagedRefreshes < ActiveRecord::Migration
  def change
    create_table :tpl_birst_staged_refreshes do |t|
      t.references :data_source_collection, index: true
      t.references :process_group_collection, index: true
      t.references :production_space, index: true
      t.references :staging_space, index: true

      t.timestamps
    end
  end
end
