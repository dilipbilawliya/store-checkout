require 'json'
require 'byebug'

class Checkout
  attr_reader :rules, :cart

  def initialize(rules_file)
    @rules = load_rules(rules_file)
    @cart = Hash.new(0)
  end

  def scan(item)
    @cart[item] += 1
  end

  def total
    total_price = 0.0
    @cart.each do |item, quantity|
      total_price += calculate_item_price(item, quantity)
    end
    total_price.round(2)
  end

  private

  def load_rules(rules_file)
    JSON.parse(File.read(rules_file))
  end

  def calculate_item_price(item, quantity)
    rules = @rules[item]
    base_price = rules['price'] * quantity
    return 0 unless @rules[item]

    if rules['discount']&.any? { |d| d =~ /\d+-for-\d+/ }
      buy_sets, remaining_quantity, buy_quantity, free_quantity = calculate_buy_sets_and_remaining_quantity(quantity, rules['discount'])
      base_price = calculate_price_for_buy_sets(buy_sets, rules['price'], buy_quantity)
      base_price += remaining_quantity * rules['price']
      base_price = apply_bulk_discount(base_price, rules) if rules['discount'].include?('bulk') && quantity >= rules['bulk_quantity']
    elsif rules['discount'] && rules['discount'].first == 'bulk' && quantity >= rules['bulk_quantity']
      base_price = apply_bulk_discount(base_price, rules)
    end
    
    base_price
  end
  
  def calculate_buy_sets_and_remaining_quantity(quantity, discount)
    promotion_discount = discount.find { |d| d =~ /\d+-for-\d+/ }
    return [0, quantity] unless promotion_discount
  
    buy_quantity, free_quantity = promotion_discount.scan(/\d+/).map(&:to_i)
    buy_quantity -= free_quantity
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
