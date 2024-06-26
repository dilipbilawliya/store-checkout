# frozen_string_literal: true

require_relative '../lib/checkout'

RSpec.describe Store do
  let(:store) {Store.new('rules.json')}
  let(:products) {store.products}

  describe '#scan' do
    it 'adds items to the cart' do
      checkout = Checkout.new(products)
      checkout.scan('VOUCHER')
      checkout.scan('TSHIRT')
      expect(checkout.cart.items).to eq({ 'VOUCHER' => 1, 'TSHIRT' => 1 })
    end

    it 'increments quantity when same item scanned again' do
      checkout = Checkout.new(products)
      checkout.scan('VOUCHER')
      checkout.scan('VOUCHER')
      expect(checkout.cart.items['VOUCHER']).to eq(2)
    end
  end

  describe '#total' do
    it 'returns 0 for an empty cart' do
      checkout = Checkout.new(products)
      expect(checkout.total).to eq(0)
    end

    it 'calculates the total price without discounts' do
      checkout = Checkout.new(products)
      checkout.scan('VOUCHER')
      checkout.scan('TSHIRT')
      expect(checkout.total).to eq(25.00)
    end

    it 'applies 2-for-1 discount on VOUCHER items' do
      checkout = Checkout.new(products)
      checkout.scan('VOUCHER')
      checkout.scan('VOUCHER')
      expect(checkout.total).to eq(5.00)
    end

    it 'applies 2-for-1 discount on VOUCHER items' do
      checkout = Checkout.new(products)
      checkout.scan('VOUCHER')
      checkout.scan('TSHIRT')
      checkout.scan('VOUCHER')
      expect(checkout.total).to eq(25.00)
    end

    it 'applies bulk discount on TSHIRT items' do
      checkout = Checkout.new(products)
      4.times { checkout.scan('TSHIRT') }
      expect(checkout.total).to eq(76.00)
    end

    it 'applies both discounts correctly' do
      checkout = Checkout.new(products)
      3.times { checkout.scan('TSHIRT') }
      checkout.scan('VOUCHER')
      expect(checkout.total).to eq(62.00)
    end

    it 'handles multiple items with different discounts' do
      checkout = Checkout.new(products)
      checkout.scan('VOUCHER')
      checkout.scan('TSHIRT')
      checkout.scan('VOUCHER')
      checkout.scan('VOUCHER')
      expect(checkout.total).to eq(30.00)
    end

    it 'applies bulk discount only when quantity meets or exceeds threshold' do
      checkout = Checkout.new(products)
      2.times { checkout.scan('TSHIRT') }
      expect(checkout.total).to eq(40.00)
    end

    it 'applies no discounts if not specified in rules' do
      checkout = Checkout.new(products)
      5.times { checkout.scan('MUG') }
      expect(checkout.total).to eq(37.50)
    end
  end
end
