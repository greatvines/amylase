json.array!(@birst_extract_groups) do |birst_extract_group|
  json.extract! birst_extract_group, :id, :name, :description
  json.url birst_extract_group_url(birst_extract_group, format: :json)
end
