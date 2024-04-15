# frozen_string_literal: true

require_relative 'product'
require_relative 'promotion_discount'
require_relative 'bulk_discount'
require_relative 'quantity_calculator'

# DiscountCalculator calculates the discounted price for items based on given rules.
class DiscountCalculator
  def initialize(products)
    @products = products
    @promotion_discount = PromotionDiscount.new
    @bulk_discount = BulkDiscount.new
    @buy_sets_and_remaining_quantity = QuantityCalculator.new
  end

  # Calculates the discounted price for an item based on the quantity.
  def apply_discount(item, quantity)
    rules = @products[item]
    return 0 unless rules

    base_price = calculate_base_price(rules, quantity)
    if @promotion_discount.check(rules) &&  @bulk_discount.check(rules, quantity)
      base_price = apply_bulk_and_promotion_discounts(base_price, rules, quantity)
    elsif @promotion_discount.check(rules)
      base_price = apply_promotion_discount_only(base_price, rules, quantity)
    elsif @bulk_discount.check(rules, quantity)
      base_price = @bulk_discount.apply_bulk_discount(base_price, rules)
    end
    base_price
  end

  private

  def apply_bulk_and_promotion_discounts(base_price, rules, quantity)
    buy_sets, remaining_quantity, buy_quantity = @buy_sets_and_remaining_quantity.calculate(
        quantity, rules['discount']
      )
    bulk_discount_price = @bulk_discount.apply_bulk_discount(base_price, rules)
    promotion_discount_price = @promotion_discount.apply_promotion_discount(buy_sets, remaining_quantity, buy_quantity,
                                                                rules['price'])
    [bulk_discount_price, promotion_discount_price].min
  end

  def apply_promotion_discount_only(base_price, rules, quantity)
    buy_sets, remaining_quantity, buy_quantity = @buy_sets_and_remaining_quantity.calculate(
        quantity, rules['discount']
      )
      base_price = @promotion_discount.apply_promotion_discount(buy_sets, remaining_quantity, buy_quantity,
                                                                rules['price'])
  end 

  def calculate_base_price(rules, quantity)
    rules['price'] * quantity
  end
end
