# frozen_string_literal: true

require 'json'
require_relative 'discount_calculator'
require_relative 'store'
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
    @cart.total_price(@discount)
  end
end
