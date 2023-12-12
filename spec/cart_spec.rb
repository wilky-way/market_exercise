require_relative '../lib/cart'
require_relative '../lib/product'

describe Cart do
  let(:products) do
    {
      'CH1' => Product.new('CH1', 'Chai', 3.11),
      'AP1' => Product.new('AP1', 'Apples', 6.00),
      'CF1' => Product.new('CF1', 'Coffee', 11.23),
      'MK1' => Product.new('MK1', 'Milk', 4.75)
    }
  end
  let(:cart) { Cart.new }

  describe '#initialize' do
    it 'initializes an empty items hash' do
      expect(cart.items).to eq({})
    end
  end

  describe '#add_item' do
    it 'adds an item to the cart' do
      cart.add_item('CH1')
      expect(cart.items['CH1']).to eq(1)
    end
    it 'increments the item quantity when adding an item that already exists' do
      cart.add_item('CH1')
      cart.add_item('CH1')
      expect(cart.items['CH1']).to eq(2)
    end
  end
end
