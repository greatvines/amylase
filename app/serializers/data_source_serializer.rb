class DataSourceSerializer < ActiveModel::Serializer
  attributes :id, :name, :birst_filename, :data_source_type, :redshift_sql, :s3_path
end
