class CreateBirstExtractGroupCollections < ActiveRecord::Migration
  def change
    create_table :birst_extract_group_collections do |t|
      t.text :name, :null => false
      t.text :description

      t.timestamps
    end

    add_index :birst_extract_group_collections, :name, unique: true
  end
end
