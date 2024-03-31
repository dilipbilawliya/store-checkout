require_relative 'lib/checkout'

puts "Enter the items to scan (separated by comma):"
puts "Example:- TSHIRT, VOUCHER, MUG...etc"
input_items = gets.chomp.split(',').map(&:strip)

checkout = Checkout.new('rules.json')

input_items.each do |item|
  checkout.scan(item)
end
puts "Total: #{checkout.total} $"
