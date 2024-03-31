require_relative '../lib/checkout'

RSpec.describe Checkout do
  let(:rules_file) { 'rules.json' }

  describe '#scan' do
    it 'adds items to the cart' do
      co = Checkout.new(rules_file)
      co.scan('VOUCHER')
      co.scan('TSHIRT')
      expect(co.cart).to eq({ 'VOUCHER' => 1, 'TSHIRT' => 1 })
    end

    it 'increments quantity when same item scanned again' do
      co = Checkout.new(rules_file)
      co.scan('VOUCHER')
      co.scan('VOUCHER')
      expect(co.cart['VOUCHER']).to eq(2)
    end
  end
end
