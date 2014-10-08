json.array!(@data_source_groups) do |data_source_group|
  json.extract! data_source_group, :id, :name
  json.url data_source_group_url(data_source_group, format: :json)
end
