# frozen_string_literal: true

require_relative 'discount_applier'

# DiscountCalculator calculates the discounted price for items based on given rules.
class DiscountCalculator
  def initialize(rules)
    @rules = rules
    @discount_applier = DiscountApplier.new
  end

  # Calculates the discounted price for an item based on the quantity.
  def apply(item, quantity)
    rules = @rules[item]
    return 0 unless rules

    base_price = calculate_base_price(rules, quantity)
    @discount_applier.apply(base_price, rules, quantity)
  end

  private

  def calculate_base_price(rules, quantity)
    rules['price'] * quantity
  end
end
