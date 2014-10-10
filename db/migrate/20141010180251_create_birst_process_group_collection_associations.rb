class CreateBirstProcessGroupCollectionAssociations < ActiveRecord::Migration
  def change
    create_table :birst_process_group_collection_associations do |t|

      t.timestamps
    end
  end
end
