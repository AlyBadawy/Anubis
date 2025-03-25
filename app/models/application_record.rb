class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  self.implicit_order_column = :created_at

  before_create :generate_uuid_v7

  private

  def generate_uuid_v7
    return if self.class.attribute_types["id"].type != :uuid

    self.id ||= Random.uuid_v7
  end
end
