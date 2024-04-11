# frozen_string_literal: true

require 'json'
require_relative 'discount_calculator'
require_relative 'product'
require_relative 'cart'

# Checkout class represents a shopping cart checkout system.
class Checkout
  attr_reader :cart

  def initialize(products)
    @discount = DiscountCalculator.new(products)
    @cart = Cart.new
  end

  def scan(item)
    @cart.add_item(item)
  end

  def total
    total_price = 0.0
    @cart.items.each do |item, quantity|
      total_price += @discount.apply(item, quantity)
    end
    total_price.round(2)
  end
end
