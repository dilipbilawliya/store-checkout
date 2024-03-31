require 'json'
require_relative 'discount_calculator'

class Checkout
  attr_reader :cart

  def initialize(rules_file)
    @rules = load_rules(rules_file)
    @discount = DiscountCalculator.new(@rules)
    @cart = Hash.new(0)
  end

  def scan(item)
    @cart[item] += 1
  end

  def total
    total_price = 0.0
    @cart.each do |item, quantity|
      total_price += @discount.apply(item, quantity)
    end
    total_price.round(2)
  end

  private

  def load_rules(rules_file)
    JSON.parse(File.read(rules_file))
  end
end
