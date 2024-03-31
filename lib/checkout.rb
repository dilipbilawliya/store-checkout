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
    base_price = 0
    remaining_quantity = quantity
    if @rules[item]['discount'].length == 2
      promotion_discount = ''
      @rules[item]['discount'].each do |discount|
        promotion_discount = discount if discount =~ /\d-for-\d+/
      end
      buy_quantity = promotion_discount[0].to_i - promotion_discount[-1].to_i
      free_quantity = promotion_discount[-1].to_i
      
      buy_sets = quantity / (buy_quantity + free_quantity)
      base_price += buy_sets * (buy_quantity * @rules[item]['price'])
      remaining_quantity -= buy_sets * (buy_quantity + free_quantity)
      base_price += remaining_quantity * @rules[item]['price']
      base_price = @rules[item]['bulk_price'] * (base_price/@rules[item]['price']) if (base_price/@rules[item]['price']) >= @rules[item]['bulk_quantity']

    elsif @rules[item]['discount'].first == 'bulk' && quantity >= @rules[item]['bulk_quantity']
      base_price = @rules[item]['bulk_price'] * quantity
    elsif @rules[item]['discount'].first =~ /\d-for-\d+/
      promotion_discount = @rules[item]['discount'].first

      buy_quantity = promotion_discount[0].to_i - promotion_discount[-1].to_i
      free_quantity = promotion_discount[-1].to_i
      buy_sets = quantity / (buy_quantity + free_quantity)
      base_price += buy_sets * (buy_quantity * @rules[item]['price'])
      remaining_quantity -= buy_sets * (buy_quantity + free_quantity)
      base_price += remaining_quantity * @rules[item]['price']
    end
    base_price
  end
end
