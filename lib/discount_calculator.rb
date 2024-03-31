class DiscountCalculator
  def initialize(rules)
    @rules = rules
  end

  def apply(item, quantity)
    return 0 unless @rules[item]

    rules = @rules[item]
    base_price = rules['price'] * quantity

    if rules['discount'] && rules['discount'].any? { |d| d =~ /\d+-for-\d+/ }
      buy_sets, remaining_quantity, buy_quantity, free_quantity = calculate_buy_sets_and_remaining_quantity(quantity, rules['discount'])
      base_price = calculate_price_for_buy_sets(buy_sets, rules['price'], buy_quantity)
      base_price += remaining_quantity * rules['price']
      base_price = apply_bulk_discount(base_price, rules) if rules['discount'].include?('bulk') && quantity >= rules['bulk_quantity']
    elsif rules['discount'] && rules['discount'].first == 'bulk' && quantity >= rules['bulk_quantity']
      base_price = apply_bulk_discount(base_price, rules)
    end

    base_price
  end

  private

  def calculate_buy_sets_and_remaining_quantity(quantity, discount)
    promotion_discount = discount.find { |d| d =~ /\d+-for-\d+/ }
    return [0, quantity] unless promotion_discount
    free_quantity, buy_quantity = promotion_discount.scan(/\d+/).map(&:to_i)
    free_quantity -= buy_quantity
    buy_sets = quantity / (buy_quantity + free_quantity)
    remaining_quantity = quantity % (buy_quantity + free_quantity)
    [buy_sets, remaining_quantity, buy_quantity, free_quantity]
  end

  def calculate_price_for_buy_sets(buy_sets, price_per_set, buy_quantity)
    buy_sets * (buy_quantity * price_per_set)
  end

  def apply_bulk_discount(base_price, rules)
    if base_price >= rules['bulk_quantity'] * rules['price']
      rules['bulk_price'] * (base_price / rules['price'])
    else
      base_price
    end
  end
end
