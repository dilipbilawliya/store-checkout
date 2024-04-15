# frozen_string_literal: true

# Calculates quantities for discounts based on specified rules.
class QuantityCalculator
  def calculate(quantity, discount)
    promotion_discount = find_promotion_discount(discount)

    free_quantity, buy_quantity = extract_quantities(promotion_discount)
    calculate_quantities(quantity, free_quantity, buy_quantity)
  end

  private

  def find_promotion_discount(discount)
    discount.find { |d| d =~ /\d+-for-\d+/ }
  end

  def extract_quantities(promotion_discount)
    promotion_discount.scan(/\d+/).map(&:to_i)
  end

  def calculate_quantities(quantity, free_quantity, buy_quantity)
    buy_sets = quantity / free_quantity
    remaining_quantity = quantity % free_quantity
    [buy_sets, remaining_quantity, buy_quantity]
  end
end
