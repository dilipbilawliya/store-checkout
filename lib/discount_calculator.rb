# frozen_string_literal: true

# DiscountCalculator calculates the discounted price for items based on given rules.
class DiscountCalculator
  def initialize(rules)
    @rules = rules
  end

  # Calculates the discounted price for an item based on the quantity.
  def apply(item, quantity)
    return 0 unless @rules[item]

    rules = @rules[item]
    base_price = calculate_base_price(rules, quantity)
    apply_discounts(base_price, rules, quantity)
  end

  private

  def calculate_base_price(rules, quantity)
    rules['price'] * quantity
  end

  def apply_discounts(base_price, rules, quantity)
    if promotion_discount?(rules)
      buy_sets, remaining_quantity, buy_quantity = calculate_buy_sets_and_remaining_quantity(
        quantity, rules['discount']
      )
      base_price = apply_promotion_discount(buy_sets, remaining_quantity, buy_quantity, rules['price'])
    end

    base_price = apply_bulk_discount(base_price, rules) if bulk_discount?(rules, quantity)
    base_price
  end

  def promotion_discount?(rules)
    rules['discount']&.any? { |d| d =~ /\d+-for-\d+/ }
  end

  def calculate_buy_sets_and_remaining_quantity(quantity, discount)
    promotion_discount = discount.find { |d| d =~ /\d+-for-\d+/ }
    return [0, quantity] unless promotion_discount

    free_quantity, buy_quantity = promotion_discount.scan(/\d+/).map(&:to_i)
    free_quantity -= buy_quantity
    buy_sets = quantity / (buy_quantity + free_quantity)
    remaining_quantity = quantity % (buy_quantity + free_quantity)
    [buy_sets, remaining_quantity, buy_quantity]
  end

  def apply_promotion_discount(buy_sets, remaining_quantity, buy_quantity, price_per_set)
    buy_sets * (buy_quantity * price_per_set) + remaining_quantity * price_per_set
  end

  def bulk_discount?(rules, quantity)
    rules['discount']&.include?('bulk') && quantity >= rules['bulk_quantity']
  end

  def apply_bulk_discount(base_price, rules)
    if base_price >= rules['bulk_quantity'] * rules['price']
      rules['bulk_price'] * (base_price / rules['price'])
    else
      base_price
    end
  end
end
