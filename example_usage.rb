# frozen_string_literal: true

require_relative 'lib/checkout'

puts 'Enter the items to scan (separated by comma):'
puts 'Example:- TSHIRT, VOUCHER, MUG...etc'

input_items = gets.chomp.split(',').map(&:strip)

store = Store.new('rules.json')
products = store.products

checkout = Checkout.new(products)

input_items.each do |item|
  checkout.scan(item)
end
puts "Total: #{checkout.total} $"
