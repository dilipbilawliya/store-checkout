# frozen_string_literal: true

require_relative 'promotion_discount'
require_relative 'bulk_discount'
require_relative 'discount_quantity_calculator'

# Applies discounts to items based on specified rules.
class DiscountApplier
  def initialize
    @promotion_discount = PromotionDiscount.new
    @bulk_discount = BulkDiscount.new
    @buy_sets_and_remaining_quantity = DiscountQuantityCalculator.new
  end

  def apply(base_price, rules, quantity)
    if @promotion_discount.check(rules)
      buy_sets, remaining_quantity, buy_quantity = @buy_sets_and_remaining_quantity.calculate(
        quantity, rules['discount']
      )

      base_price = @promotion_discount.apply_promotion_discount(buy_sets, remaining_quantity, buy_quantity,
                                                                rules['price'])
    end

    base_price = @bulk_discount.apply_bulk_discount(base_price, rules) if @bulk_discount.check(rules, quantity)
    base_price
  end
end
