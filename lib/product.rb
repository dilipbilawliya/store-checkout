# frozen_string_literal: true

class Product
  def initialize(rules_file)
    @product_data = load_products(rules_file)
  end

  def find_product(item)
    @product_data[item]
  end

  private

  def load_products(rules_file)
    JSON.parse(File.read(rules_file))
  end
end
