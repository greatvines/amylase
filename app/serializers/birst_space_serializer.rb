class BirstSpaceSerializer < ActiveModel::Serializer
  attributes :id, :name, :type, :space_id
  has_one :client
end
