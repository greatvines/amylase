class BirstSpace < ActiveRecord::Base
  after_initialize :defaults, unless: :persisted?
  SPACE_TYPES = %w(production staging uat development master other)
  SPACE_UUID_REGEX = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/

  belongs_to :client

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :space_uuid
  validates_inclusion_of :space_type, in: SPACE_TYPES, allow_nil: false
  validates_format_of :space_uuid, with: SPACE_UUID_REGEX, message: "space uuid must be a valid UUID (e.g., 5efddbea-3481-46fd-b7c1-4e04046cefb7)"

  belongs_to :birst_space

  validate :maximum_same_space_types_per_client

  # Public: Validator used to guarantee that only one production, staging, or uat space
  # is created per client.
  #
  # Returns nothing.
  def maximum_same_space_types_per_client
    return unless %w(production staging uat).include? self.space_type

    client_spaces_same_type = BirstSpace.where(client_id: self.client_id, space_type: self.space_type)

    if client_spaces_same_type.collect { |space| id != self.id }.count > 0
      errors.add(:space_type_max, "Only 1 #{self.space_type} space allowed per client")
    end
  end


  def defaults
    self.space_type ||= 'other'
  end
end
