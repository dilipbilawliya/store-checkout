require 'json'
require 'byebug'

class Checkout
  attr_reader :cart

  def initialize
    @cart = Hash.new(0)
  end

  def scan(item)
    @cart[item] += 1
  end
end
