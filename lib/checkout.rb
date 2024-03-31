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

  private

  def load_rules(rules_file)
    JSON.parse(File.read(rules_file))
  end
end
