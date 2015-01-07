json.array!(@tpl_gooddata_extracts) do |tpl_gooddata_extract|
  json.extract! tpl_gooddata_extract, :id, :gooddata_project_id, :destination_credential_id, :destination_path
  json.url tpl_gooddata_extract_url(tpl_gooddata_extract, format: :json)
end
