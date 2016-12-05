class Meal < ApplicationRecord
  has_many :ingredients, inverse_of: :meal, dependent: :destroy
  accepts_nested_attributes_for :ingredients, allow_destroy: true

  ### form stuff from here on
  attr_reader :new_ingredient

  def assign_attributes(attributes)
    @new_ingredient = attributes[:new_ingredient]
    @create_ingredient = attributes[:create_ingredient]
    super attributes.select{ |k, _| [*Meal.attribute_names, 'ingredients_attributes'].include?(k) }
  end

  def save(*args)
    return false if @new_ingredient || @create_ingredient
    super
  end
end
