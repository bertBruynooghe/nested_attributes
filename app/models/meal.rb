class Meal < ApplicationRecord
  has_many :ingredients, inverse_of: :meal, dependent: :destroy
  accepts_nested_attributes_for :ingredients, allow_destroy: true

  ### form stuff from here on
  attr_reader :ingredient_index
  attr_reader :ingredient_action

  def assign_attributes(new_attributes)
    extract_ingredients_action_args(new_attributes)
    super
  end

  def save(*args)
    # don't save yet if we're coming if we're about to start/finishing an ingredient edit
    return false if @ingredient_index
    super
  end

  private

  def extract_ingredients_action_args(new_attributes)
    (new_attributes[:ingredients_attributes] || []).each do |index, ingredient_attributes|
      extract_ingredient_action_args(index, ingredient_attributes)
    end
  end

  def extract_ingredient_action_args(index, ingredient_attributes)
    %w(edit update).each do |action|
      if ingredient_attributes.delete(action)
        @ingredient_index = index.to_i
        @ingredient_action = action.to_sym
      end
    end
    if ingredient_attributes['_destroy'] && ingredient_attributes['_destroy'] != 'true'
      ingredient_attributes['_destroy'] = 'true'
      @ingredient_index = index.to_i
      @ingredient_action = :_destroy
    end
  end
end
