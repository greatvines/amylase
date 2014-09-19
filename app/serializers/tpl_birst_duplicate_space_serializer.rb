class TplBirstDuplicateSpaceSerializer < ActiveModel::Serializer
  attributes :id, :from_space_id_str, :to_space_name, :with_membership, :with_data
end
