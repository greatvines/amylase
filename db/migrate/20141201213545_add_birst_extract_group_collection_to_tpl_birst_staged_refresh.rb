class AddBirstExtractGroupCollectionToTplBirstStagedRefresh < ActiveRecord::Migration
  def change
    add_reference :tpl_birst_staged_refreshes, :birst_extract_group_collection, index: { name: 'idx_tpl_staged_refresh_extract_group_collection' }
  end
end
