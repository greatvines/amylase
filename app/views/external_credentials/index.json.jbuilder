json.array!(@external_credentials) do |external_credential|
  json.extract! external_credential, :id, :name, :description, :username, :password
  json.url external_credential_url(external_credential, format: :json)
end
