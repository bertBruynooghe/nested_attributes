class Meal < ApplicationRecord
  has_many :ingredients, inverse_of: :meal, dependent: :destroy
  accepts_nested_attributes_for :ingredients, allow_destroy: true
end
