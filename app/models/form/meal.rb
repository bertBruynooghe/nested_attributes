module Form
  class Meal
    def initialize(meal)
      @meal = meal
    end

    def model
      @meal
    end

    def persisted?
      #needed to get form_for working correctly
      @meal.persisted?
    end

    def assign_attibutes(attributes)
      @meal.assign_attributes(attributes.reject{ |k, _| k == 'commit' })
      @commit = attributes[:commit]
    end

    def save(*args)
      @meal.save(*args)
    end

    def method_missing(method, *args)
      @meal.send(method, *args)
    end
  end
end
