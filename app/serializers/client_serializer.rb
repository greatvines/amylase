class ClientSerializer < ActiveModel::Serializer
  attributes :id, :name, :redshift_schema, :salesforce_username
end
