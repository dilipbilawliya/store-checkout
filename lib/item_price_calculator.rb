# frozen_string_literal: true

# Calculates base price for items based on specified rules.
class ItemPriceCalculator
  def initialize(rule)
    @rule = rule
  end

  def calculate_base_price(quantity)
    @rule.price * quantity
  end
end
