json.array!(@birst_process_groups) do |birst_process_group|
  json.extract! birst_process_group, :id, :name, :description
  json.url birst_process_group_url(birst_process_group, format: :json)
end
