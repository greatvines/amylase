class TplGooddataExtractReportSerializer < ActiveModel::Serializer
  attributes :id, :name, :report_oid, :destination_file_name
  has_one :tpl_gooddata_extract
end
