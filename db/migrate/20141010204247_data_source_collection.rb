class DataSourceCollection < ActiveRecord::Migration
  def change

    create_table :data_source_collections do |t|
      t.text :name, :null => false

      t.timestamps
    end

    add_index :data_source_collections, :name, unique: true


    create_table :data_source_collection_associations do |t|
      t.belongs_to :data_source
      t.belongs_to :data_source_collection

      t.timestamps
    end

    add_index :data_source_collection_associations, [:data_source_id, :data_source_collection_id], unique: true, name: 'idx_data_source_collections_associations'
    add_index :data_source_collection_associations, :data_source_collection_id, name: 'idx_data_source_collections_association_data_source_collection'
  end
end
