json.array!(@birst_spaces) do |birst_space|
  json.extract! birst_space, :id, :name, :client_id, :type, :space_id
  json.url birst_space_url(birst_space, format: :json)
end
