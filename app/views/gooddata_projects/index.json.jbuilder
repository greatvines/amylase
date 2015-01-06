json.array!(@gooddata_projects) do |gooddata_project|
  json.extract! gooddata_project, :id, :name, :description, :project_uid, :client_id
  json.url gooddata_project_url(gooddata_project, format: :json)
end
