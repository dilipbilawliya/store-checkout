require_relative 'product'

class Store
  def initialize(rules_file)
    @product = Product.new(rules_file)
  end

  def products
    @product.product_data
  end
end