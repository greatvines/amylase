class CreateBirstProcessGroupCollections < ActiveRecord::Migration
  def change
    create_table :birst_process_group_collections do |t|
      t.text :name
      t.text :description

      t.timestamps
    end
  end
end
