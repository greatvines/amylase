json.array!(@clients) do |client|
  json.extract! client, :id, :name, :redshift_schema, :salesforce_username
  json.url client_url(client, format: :json)
end
