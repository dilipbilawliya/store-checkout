# frozen_string_literal: true

class Product
  attr_reader :product_data

  def initialize(rules_file)
    @product_data = load_products(rules_file)
  end

  private

  def load_products(rules_file)
    JSON.parse(File.read(rules_file))
  rescue Errno::ENOENT => e
    puts "Error loading product data: #{e.message}"
    {}
  rescue JSON::ParserError => e
    puts "Error parsing product data: #{e.message}"
    {}
  end
end
