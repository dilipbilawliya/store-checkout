# frozen_string_literal: true

# Cart class manages the items added to the shopping cart.
class Cart
  attr_reader :items
  
  def initialize
    @items = Hash.new(0)
  end

  def add_item(product)
    @items[product] += 1
  end

  def total_price(discount_calculator)
    total_price = 0.0
    @items.each do |item, quantity|
      total_price += discount_calculator.apply_discount(item, quantity)
    end
    total_price.round(2)
  end
end
