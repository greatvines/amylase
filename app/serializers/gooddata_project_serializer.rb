class GooddataProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :project_uid
  has_one :client
end
