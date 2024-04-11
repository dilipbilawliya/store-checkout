# frozen_string_literal: true

class Cart
  attr_reader :items
  
  def initialize
    @items = Hash.new(0)
  end

  def add_item(product)
    @items[product] += 1
  end
end
