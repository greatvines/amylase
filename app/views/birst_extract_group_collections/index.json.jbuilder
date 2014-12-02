json.array!(@birst_extract_group_collections) do |birst_extract_group_collection|
  json.extract! birst_extract_group_collection, :id, :name, :description
  json.url birst_extract_group_collection_url(birst_extract_group_collection, format: :json)
end
