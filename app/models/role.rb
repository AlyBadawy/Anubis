class Role < ApplicationRecord
  normalizes :role_name, with: ->(e) { e.strip.titleize }

  validates :role_name, presence: true, uniqueness: true
end
