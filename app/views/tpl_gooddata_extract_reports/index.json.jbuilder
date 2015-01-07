json.array!(@tpl_gooddata_extract_reports) do |tpl_gooddata_extract_report|
  json.extract! tpl_gooddata_extract_report, :id, :name, :tpl_gooddata_extract_id, :report_oid, :destination_file_name
  json.url tpl_gooddata_extract_report_url(tpl_gooddata_extract_report, format: :json)
end
