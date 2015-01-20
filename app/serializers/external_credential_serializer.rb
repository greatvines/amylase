class ExternalCredentialSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :username, :password
end
