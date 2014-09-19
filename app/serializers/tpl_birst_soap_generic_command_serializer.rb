class TplBirstSoapGenericCommandSerializer < ActiveModel::Serializer
  attributes :id, :command, :argument_json
end
