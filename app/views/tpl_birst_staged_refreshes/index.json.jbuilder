json.array!(@tpl_birst_staged_refreshes) do |tpl_birst_staged_refresh|
  json.extract! tpl_birst_staged_refresh, :id, :data_source_collection_id, :process_group_collection_id, :production_space_id, :staging_space_id
  json.url tpl_birst_staged_refresh_url(tpl_birst_staged_refresh, format: :json)
end
