module Forms
  class Meal
    attr_reader :ingredient_index
    attr_reader :ingredient_action

    def initialize(meal_or_attributes)
      if meal_or_attributes.is_a?(::Meal)
        @meal = meal_or_attributes
      else
        @meal = ::Meal.new
        assign_attributes(meal_or_attributes)
      end
    end

    # custom behaviour of the Forms::Meal
    def assign_attributes(new_attributes)
      extract_ingredients_action_args(new_attributes)
      @meal.assign_attributes(new_attributes)
    end

    def save(*args)
      # don't save yet if we're coming if we're about to start/finishing an ingredient edit
      return false if @ingredient_index
      @meal.save
    end

    def method_missing(method, *args)
      @meal.send(method, *args)
    end

    def self.method_missing(method, *args)
      ::Meal.send(method, *args)
    end

    # needed for proper form submission path in form view
    delegate :persisted?, to: :meal

    # needed for fields_for functionality in form view
    delegate :ingredients, :ingredients=, :ingredients_attributes=, to: :meal

    private

    attr_reader :meal

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

      # when coming from the new/edit ingredients dialog, the value of the _destroy attribute can be the label of the delete button
      # we're using this value to discern between values that were set before or newly set values to see where the submit is coming from
      if ingredient_attributes['_destroy'] && ingredient_attributes['_destroy'] != 'true'
        ingredient_attributes['_destroy'] = 'true'
        @ingredient_index = index.to_i
        @ingredient_action = :_destroy
      end
    end
  end
end
