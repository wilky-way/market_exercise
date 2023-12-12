require_relative '../lib/discounts'
require_relative '../lib/printer'
require_relative '../lib/product'

describe Discounts do
  let(:products) do
    {
      'CH1' => Product.new('CH1', 'Chai', 3.11),
      'AP1' => Product.new('AP1', 'Apples', 6.00),
      'CF1' => Product.new('CF1', 'Coffee', 11.23),
      'MK1' => Product.new('MK1', 'Milk', 4.75)
    }
  end
  let(:printer) { Printer.new }
  # let(:cart) { Cart.new }
  let(:discounts) { Discounts.new(products, {}) }

  describe '#initialize' do
    it 'initializes a Printer object' do
      expect(discounts.printer).to be_a(Printer)
    end
    it 'initializes the products instance variable' do
      expect(discounts.products).to eq(products)
    end
    it 'sets the cart instance variable' do
      expect(discounts.cart).to eq({})
    end
    it 'sets the bogo_flag instance variable to false' do
      expect(discounts.bogo_flag).to eq(false)
    end
    it 'sets the chmk_count instance variable to 0' do
      expect(discounts.chmk_count).to eq(0)
    end
  end

  describe '#apply_discounts' do
    it 'returns the price of the product if no discount exists for a product code' do
      expect(discounts.apply_discounts('CH1')).to eq(3.11)
    end
    it 'calls the bogo method if the code is CH1' do
      expect(discounts).to receive(:bogo).with('CF1')
      discounts.apply_discounts('CF1')
    end
    it 'calls the appl method if the code is AP1' do
      discounts = Discounts.new(products, { 'AP1' => 1 })
      expect(discounts).to receive(:appl).with('AP1', 1)
      discounts.apply_discounts('AP1')
    end
    it 'calls the chmk method if the code is MK1' do
      expect(discounts).to receive(:chmk).with('MK1')
      discounts.apply_discounts('MK1')
    end
  end

  describe '#bogo' do
    it 'sets the bogo flag to true if it is false' do
      discounts.bogo('CF1')
      expect(discounts.bogo_flag).to eq(true)
    end
    it 'sets the bogo flag to false if there are 2 coffees' do
      discounts.bogo('CF1')
      discounts.bogo('CF1')
      expect(discounts.bogo_flag).to eq(false)
    end
    it 'returns the price of a coffee there is 1' do
      items = { 'CF1' => 1 }
      discounts = Discounts.new(products, items)
      expect(discounts.bogo('CF1')).to eq(11.23)
    end
    it 'returns 0 if there are 2 coffees' do
      items = { 'CF1' => 2 }
      discounts = Discounts.new(products, items)

      # Simulate bogo flag being set to true from the first coffee
      discounts.bogo('CF1')

      expect(discounts.bogo('CF1')).to eq(0)
    end
    it 'returns the price of a coffee if there are 3 coffees' do
      items = { 'CF1' => 3 }
      discounts = Discounts.new(products, items)

      # Simulate bogo flag being set to true from the first coffee, 
      # then set it to false from the second coffee
      discounts.bogo('CF1')
      discounts.bogo('CF1')

      expect(discounts.bogo('CF1')).to eq(11.23)
    end
  end

  describe '#appl' do
    it 'returns the price of apples if there are less than 3' do
      expect(discounts.appl('AP1', 2)).to eq(6.00)
    end
    it 'returns the price of apples minus 1.50 if there are 3 or more' do
      expect(discounts.appl('AP1', 3)).to eq(4.50)
    end
  end

  describe '#chmk' do
    it 'returns the price of milk if there is no chai' do
      items = { 'MK1' => 1 }
      discounts = Discounts.new(products, items)
      expect(discounts.chmk('MK1')).to eq(4.75)
    end
    it 'returns the price of milk if there is chai and the milk count is 1' do
      items = { 'CH1' => 1, 'MK1' => 1 }
      discounts = Discounts.new(products, items)
      expect(discounts.chmk('MK1')).to eq(0)
    end
    it 'returns the price of milk if there is chai and the milk count is 2' do
      items = { 'CH1' => 1, 'MK1' => 2 }
      discounts = Discounts.new(products, items)

      # Simulate chmk_count being incremented to 1 from the first milk
      discounts.chmk('MK1')

      expect(discounts.chmk('MK1')).to eq(4.75)
    end
  end
end
