require_relative 'lib/checkout'

puts "Enter the items to scan (separated by comma):"
puts "Example:- TSHIRT, VOUCHER, MUG...etc"
input_items = gets.chomp.split(',').map(&:strip)

co = Checkout.new('rules.json')

input_items.each do |item|
  co.scan(item)
end
puts "Total: #{co.total} $"
