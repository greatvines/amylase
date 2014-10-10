json.array!(@data_source_collections) do |data_source_collection|
  json.extract! data_source_collection, :id, :name
  json.url data_source_collection_url(data_source_collection, format: :json)
end
