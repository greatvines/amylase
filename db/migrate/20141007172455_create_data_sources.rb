class CreateDataSources < ActiveRecord::Migration
  def change
    create_table :data_sources do |t|
      t.text :name, :null => false
      t.text :birst_filename
      t.text :data_source_type, :null => false
      t.text :redshift_sql
      t.text :s3_path

      t.timestamps
    end

    add_index :data_sources, :name, unique: true

  end
end
