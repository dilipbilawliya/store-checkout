# frozen_string_literal: true

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

desc 'Remove a product'
task :remove_product do
  products = load_products
  name = ask_input("Enter the name of the product to remove select from the following #{products.keys}").upcase
  if products.delete(name)
    save_products(products)
    puts "Product #{name} removed successfully."
  else
    puts "Product #{name} not found."
  end
end

desc 'Add a discount to a product'
task :add_discount do
  products = load_products
  name = ask_input('Enter the name of the product to add discount').upcase
  product = products[name]

  unless product
    puts "Product '#{name}' not found."
    next
  end
  discount = ask_input('Enter the discount (e.g bulk, 2-for-1)')

  if discount_already_added?(product, discount)
    puts "Discount type '#{discount}' already added. Please remove it before adding a new one."
    next
  end

  add_discount_to_product(product, discount)

  if discount == 'bulk'
    bulk_quantity_prompt = "Enter Bulk Quantity (current quantity:- #{product['bulk_quantity']}) (leave blank for none)"
    bulk_price_prompt = "Enter Bulk Price (current bulk price:- #{product['bulk_price']}) (leave blank for none)"
    bulk_quantity = ask_input(bulk_quantity_prompt).to_i
    bulk_price = ask_input(bulk_price_prompt).to_f

    product['bulk_quantity'] = bulk_quantity
    product['bulk_price'] = bulk_price

    if bulk_price >= product['price']
      puts 'Discount price cannot be more than or equal to the actual price'
      next
    end
  end

  save_products(products)
  puts "Discount '#{discount}' added to '#{name}'."
end

desc 'Remove a discount from a product'
task :remove_discount do
  products = load_products
  name = ask_input('Enter the name of the product to remove discount from').upcase
  unless products[name]
    puts "Product #{name} not found."
    next
  end

  discount = ask_input("Enter the discount to remove from the present values #{products[name]['discount']}")
  unless products[name]['discount'].delete(discount)
    puts "Discount #{discount} not found for #{name}."
    next
  end

  if discount == 'bulk'
    products[name]['bulk_quantity'] = 0
    products[name]['bulk_price'] = 0.0
  end
  save_products(products)
  puts "Discount #{discount} removed from #{name}."
end

desc 'Modify the price of a product'
task :modify_price do
  products = load_products
  name = ask_input('Enter the name of the product to modify price').upcase
  unless products[name]
    puts "Product #{name} not found."
    next
  end

  price = ask_input("Enter the new price (current price #{products[name]['price']})").to_f
  if products[name]['discount'].include?('bulk') && products[name]['bulk_price'] >= price
    puts 'Price of the product cannot be lower or equal to the bulk discount'
    next
  end

  products[name]['price'] = price
  save_products(products)
  puts "Price updated for #{name}."
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
  $stdin.gets.chomp
end

def discount_already_added?(product, discount)
  if discount =~ /\d+-for-\d+/
    product['discount']&.any? { |d| d =~ /\d+-for-\d+/ }
  else
    product['discount']&.include?(discount)
  end
end

def add_discount_to_product(product, discount)
  product['discount'] ||= []
  product['discount'] << discount
end
