# frozen_string_literal: true

# Represents a bulk discount applied to items.
class BulkDiscount
  def check(rules, quantity)
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
