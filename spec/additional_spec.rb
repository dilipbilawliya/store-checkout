# frozen_string_literal: true

require_relative '../lib/checkout'

RSpec.describe Store do
  let(:products) {
    products = {
      "VOUCHER" => {
        "price" => 5.0,
        "discount" => [
          "2-for-1"
        ]
      },
      "TSHIRT" => {
        "price" => 20.0,
        "discount" => [
          "bulk", "3-for-2"
        ],
        "bulk_quantity" => 3,
        "bulk_price" => 19.0
      },
      "MUG" => {
        "price" => 7.5,
        "discount" => [],
        "bulk_quantity" => 0,
        "bulk_price" => 0.0
      }
    }
  }

  describe '#scan' do
    it 'sample cases' do
      checkout = Checkout.new(products)
      checkout.scan('TSHIRT')
      checkout.scan('TSHIRT')
      checkout.scan('TSHIRT')
      expect(checkout.total).to eq(40)
    end

    it 'sample cases' do
      checkout = Checkout.new(products)
      checkout.scan('TSHIRT')
      checkout.scan('TSHIRT')
      checkout.scan('TSHIRT')
      checkout.scan('TSHIRT')
      checkout.scan('TSHIRT')
      expect(checkout.total).to eq(80)
    end

    it 'sample cases' do
      checkout = Checkout.new(products)
      checkout.scan('TSHIRT')
      checkout.scan('TSHIRT')
      checkout.scan('TSHIRT')
      checkout.scan('TSHIRT')
      checkout.scan('TSHIRT')
      checkout.scan('TSHIRT')
      expect(checkout.total).to eq(80)
    end
  end
end