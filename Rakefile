require 'json'

desc 'Add a new product'
task :add_product do
  products = load_products
  name = ask_input('Product Name').upcase
  price = ask_input('Price').to_f
  discount = ask_input('Discount (leave blank for none)')
  bulk_quantity = ask_input('Bulk Quantity (leave blank for none)').to_i
  bulk_price = ask_input('Bulk Price (leave blank for none)').to_f

  product = {
    price: price,
    discount: discount.empty? ? [] : [discount],
    bulk_quantity: bulk_quantity,
    bulk_price: bulk_price
  }
  products[name] = product
  save_products(products)
  puts "Product #{name} added successfully."
end

def load_products
  JSON.parse(File.read('rules.json'))
rescue StandardError
  {}
end

def save_products(products)
  File.write('rules.json', JSON.pretty_generate(products))
end

def ask_input(prompt)
  print "#{prompt}: "
  STDIN.gets.chomp
end