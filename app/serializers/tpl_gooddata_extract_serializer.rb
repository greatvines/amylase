class TplGooddataExtractSerializer < ActiveModel::Serializer
  attributes :id, :destination_path
  has_one :gooddata_project
  has_one :destination_credential
end
