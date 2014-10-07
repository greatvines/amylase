class CreateDataSources < ActiveRecord::Migration
  def change
    create_table :data_sources do |t|
      t.text :name
      t.text :birst_filename
      t.text :data_source_type
      t.text :redshift_sql
      t.text :s3_path

      t.timestamps
    end
  end
end
