json.array!(@data_sources) do |data_source|
  json.extract! data_source, :id, :name, :birst_filename, :data_source_type, :redshift_sql, :s3_path
  json.url data_source_url(data_source, format: :json)
end
