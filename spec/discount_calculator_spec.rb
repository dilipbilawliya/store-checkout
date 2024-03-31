require_relative '../lib/discount_calculator'

RSpec.describe DiscountCalculator do
  let(:rules) { JSON.parse(File.read('rules.json')) }

  subject { DiscountCalculator.new(rules) }

  describe '#apply' do
    context 'when the item has a 2-for-1 discount' do
      it 'calculates the price correctly' do
        expect(subject.apply('VOUCHER', 2)).to eq(5.00)
        expect(subject.apply('VOUCHER', 3)).to eq(10.00)
        expect(subject.apply('VOUCHER', 4)).to eq(10.00)
      end
    end

    context 'when the item has a bulk discount' do
      it 'calculates the price correctly' do
        expect(subject.apply('TSHIRT', 2)).to eq(40.00)
        expect(subject.apply('TSHIRT', 3)).to eq(57.00)
        expect(subject.apply('TSHIRT', 4)).to eq(76.00)
      end
    end

    context 'when the item has both 2-for-1 and bulk discounts' do
      it 'applies the best discount' do
        expect(subject.apply('TSHIRT', 5)).to eq(95.00)
      end
    end

    context 'when the item has no discounts' do
      it 'calculates the price without discounts' do
        expect(subject.apply('MUG', 2)).to eq(15.00)
      end
    end

    context 'when the item does not exist in the rules' do
      it 'returns 0' do
        expect(subject.apply('NONEXISTENT', 1)).to eq(0)
      end
    end
  end
end
