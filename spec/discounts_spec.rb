require_relative '../lib/discounts'

describe Discounts do
  let(:products) do
    {
      'CH1' => Product.new('CH1', 'Chai', 3.11),
      'AP1' => Product.new('AP1', 'Apples', 6.00),
      'CF1' => Product.new('CF1', 'Coffee', 11.23),
      'MK1' => Product.new('MK1', 'Milk', 4.75)
    }
  end
  let(:cart) { Cart.new }
  # let(:discounts) { Discounts.new(products, cart.items) }

  describe '#apply_discounts' do
    it 'returns the price of the product if no discount is applied' do
      cart.add_item('CH1')
      discounts = Discounts.new(products, cart.items)
      expect(discounts.apply_discounts('CH1')).to eq(3.11)
    end
    it 'calls the bogo method if the code is CH1' do
      discounts = Discounts.new(products, cart.items)
      expect(discounts).to receive(:bogo).with('CF1')
      discounts.apply_discounts('CF1')
    end
    it 'calls the appl method if the code is AP1' do
      discounts = Discounts.new(products, cart.items)
      cart.add_item('AP1')
      expect(discounts).to receive(:appl).with('AP1', 1)
      discounts.apply_discounts('AP1')
    end
    it 'calls the chmk method if the code is MK1' do
      discounts = Discounts.new(products, cart.items)
      expect(discounts).to receive(:chmk).with('MK1')
      discounts.apply_discounts('MK1')
    end
  end

  describe '#bogo' do
    it 'sets the bogo flag to true if it is false' do
      discounts = Discounts.new(products, cart.items)
      discounts.instance_variable_set(:@bogo_flag, false)
      discounts.bogo('CF1')
      expect(discounts.instance_variable_get(:@bogo_flag)).to eq(true)
    end
    it 'sets the bogo flag to false if it is true' do
      discounts = Discounts.new(products, cart.items)
      discounts.instance_variable_set(:@bogo_flag, true)
      discounts.bogo('CF1')
      expect(discounts.instance_variable_get(:@bogo_flag)).to eq(false)
    end
    it 'returns the price of a coffee there is 1' do
      cart.add_item('CF1')
      discounts = Discounts.new(products, cart.items)
      expect(discounts.bogo('CF1')).to eq(11.23)
    end
    it 'returns 0 if there are 2 coffees' do
      cart.add_item('CF1')
      cart.add_item('CF1')
      discounts = Discounts.new(products, cart.items)
      discounts.instance_variable_set(:@bogo_flag, true)
      expect(discounts.bogo('CF1')).to eq(0)
    end
    it 'returns the price of a single coffee if there are 3 coffees' do
      cart.add_item('CF1')
      cart.add_item('CF1')
      cart.add_item('CF1')
      discounts = Discounts.new(products, cart.items)
      discounts.instance_variable_set(:@bogo_flag, false)
      expect(discounts.bogo('CF1')).to eq(11.23)
    end
  end

  describe '#appl' do
    it 'returns the price of apples if there are less than 3' do
      cart.add_item('AP1')
      discounts = Discounts.new(products, cart.items)
      expect(discounts.appl('AP1', 1)).to eq(6.00)
    end
    it 'returns the price of apples minus 1.50 if there are 3 or more' do
      cart.add_item('AP1')
      cart.add_item('AP1')
      cart.add_item('AP1')
      discounts = Discounts.new(products, cart.items)
      expect(discounts.appl('AP1', 3)).to eq(4.50)
    end
  end
end