json.array!(@birst_process_group_collections) do |birst_process_group_collection|
  json.extract! birst_process_group_collection, :id, :name, :description
  json.url birst_process_group_collection_url(birst_process_group_collection, format: :json)
end
