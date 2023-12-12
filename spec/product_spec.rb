require_relative '../lib/product'

describe Product do
  let(:product) { Product.new('CH1', 'Chai', 3.11) }

  describe '#initialize' do
    it 'sets the code instance variable' do
      expect(product.code).to eq('CH1')
    end
    it 'sets the name instance variable' do
      expect(product.name).to eq('Chai')
    end
    it 'sets the price instance variable' do
      expect(product.price).to eq(3.11)
    end
  end
end
