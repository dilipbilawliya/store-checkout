# frozen_string_literal: true

require_relative 'discount_processor'
require_relative 'product'

# DiscountCalculator calculates the discounted price for items based on given rules.
class DiscountCalculator
  def initialize(rules_file)
    @products = Product.new(rules_file)
    @discount_applier = DiscountProcessor.new
  end

  # Calculates the discounted price for an item based on the quantity.
  def apply(item, quantity)
    rules = @products.find_product(item)
    return 0 unless rules

    base_price = calculate_base_price(rules, quantity)
    @discount_applier.apply(base_price, rules, quantity)
  end

  private

  def calculate_base_price(rules, quantity)
    rules['price'] * quantity
  end
end
