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
  discount = ask_input('Enter the discount (e.g bulk, 2-for-1)')
  
  unless products[name]
    puts "Product '#{name}' not found."
    next
  end
  
  if discount_already_added?(products[name], discount)
    puts "Discount type '#{discount}' already added. Please remove it before adding a new one."
    next
  end

  add_discount_to_product(products[name], discount)
  if discount == 'bulk'
    bulk_quantity = ask_input("Enter Bulk Quantity (current quantity:- #{products[name]['bulk_quantity']}) (leave blank for none)").to_i
    bulk_price = ask_input("Enter Bulk Price (current bulk price:- #{products[name]['bulk_price']}) (leave blank for none)").to_f
    products[name]['bulk_quantity'] = bulk_quantity
    products[name]['bulk_price'] = bulk_price
    if bulk_price >= products[name]['price']
      puts "Discount price cannot be more than or equal to the actual price"
      next
    end
  end


  save_products(products)
  puts "Discount '#{discount}' added to '#{name}'."
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
