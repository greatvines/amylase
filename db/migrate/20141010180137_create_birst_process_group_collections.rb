class CreateBirstProcessGroupCollections < ActiveRecord::Migration
  def change
    create_table :birst_process_group_collections do |t|
      t.text :name, :null => false
      t.text :description

      t.timestamps
    end

    add_index :birst_process_group_collections, :name, unique: true
  end
end
