# frozen_string_literal: true

# Applies promotion discounts to items based on specified rules.
class PromotionDiscount
  def check(rules)
    rules['discount']&.any? { |d| d =~ /\d+-for-\d+/ }
  end

  def apply_promotion_discount(buy_sets, remaining_quantity, buy_quantity, product_price)
    buy_sets * (buy_quantity * product_price) + remaining_quantity * product_price
  end
end
