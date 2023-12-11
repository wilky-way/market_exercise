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
    it 'increments the quantity when adding an item that already exists' do
      cart.add_item('CH1')
      cart.add_item('CH1')
      expect(cart.items['CH1']).to eq(2)
    end
  end

  describe '#calculate_total' do
    it 'returns the total' do
      cart.add_item('CH1')
      cart.add_item('AP1')
      discounts = Discounts.new(products, cart.items)
      expect(cart.calculate_total(discounts, products)).to eq(9.11)
    end
    it 'passes test case 1' do
      cart.add_item('CH1')
      cart.add_item('AP1')
      cart.add_item('CF1')
      cart.add_item('MK1')
      discounts = Discounts.new(products, cart.items)
      expect(cart.calculate_total(discounts, products)).to eq(20.34)
    end
    it 'passes test case 2' do
      cart.add_item('MK1')
      cart.add_item('AP1')
      discounts = Discounts.new(products, cart.items)
      expect(cart.calculate_total(discounts, products)).to eq(10.75)
    end
    it 'passes test case 3' do
      cart.add_item('CF1')
      cart.add_item('CF1')
      discounts = Discounts.new(products, cart.items)
      expect(cart.calculate_total(discounts, products)).to eq(11.23)
    end
    it 'passes test case 4' do
      cart.add_item('AP1')
      cart.add_item('AP1')
      cart.add_item('CH1')
      cart.add_item('AP1')
      discounts = Discounts.new(products, cart.items)
      expect(cart.calculate_total(discounts, products)).to eq(16.61)
    end
    it 'passes test case 5' do
      cart.add_item('CF1')
      cart.add_item('CF1')
      cart.add_item('CF1')
      cart.add_item('CF1')
      cart.add_item('CF1')
      cart.add_item('AP1')
      cart.add_item('AP1')
      cart.add_item('AP1')
      cart.add_item('AP1')
      cart.add_item('AP1')
      cart.add_item('CH1')
      cart.add_item('CH1')
      cart.add_item('CH1')
      cart.add_item('CH1')
      cart.add_item('MK1')
      cart.add_item('MK1')
      cart.add_item('MK1')
      discounts = Discounts.new(products, cart.items)
      expect(cart.calculate_total(discounts, products)).to eq(78.13)
    end
  end

  describe '#print_header' do
    it 'prints the header' do
      expect { cart.print_header }.to output(/Item                           Price/).to_stdout
    end
    it 'prints the dashes' do
      expect { cart.print_header }.to output(/----                           -----/).to_stdout
    end
  end

  describe '#print_footer' do
    it 'prints the dashes' do
      expect { cart.print_footer(9.11) }.to output(/------------------------------------/).to_stdout
    end
    it 'prints the total' do
      expect { cart.print_footer(9.11) }.to output(/9.11/).to_stdout
    end
  end
end
