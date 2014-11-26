class CreateBirstExtractGroupCollectionAssociations < ActiveRecord::Migration
  def change
    create_table :birst_extract_group_collection_associations do |t|

      t.timestamps
    end
  end
end
