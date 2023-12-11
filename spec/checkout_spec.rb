require_relative '../lib/checkout'
describe Checkout do
  let(:checkout) { Checkout.new }

  describe '#initialize' do
    it 'initializes a new cart' do
      expect(checkout.cart).to be_a(Cart)
    end
    it 'initializes an empty products hash' do
      expect(checkout.products).to eq({})
    end
  end

  # This test simulates the user entering 'CH1' and 'exit' when prompted for input
  # It stubs gets and returns CH1 the first time and exit the second time
  describe '#start_checkout' do
    it 'handles user input from the command line correctly' do
      allow(checkout).to receive(:gets).and_return('CH1', 'exit')
      checkout.add_product_option('CH1', 'Chai', 3.11)
      expect { checkout.start_checkout }.to output(/Added Chai to your cart/).to_stdout
    end
  end

  describe '#scan' do
    it 'adds a product to the cart' do
      checkout.add_product_option('CH1', 'Chai', 3.11)
      checkout.scan('CH1')
      expect(checkout.cart.items['CH1']).to eq(1)
    end

    it 'increments the quantity when adding an item that already exists' do
      checkout.add_product_option('CH1', 'Chai', 3.11)
      checkout.scan('CH1')
      checkout.scan('CH1')
      expect(checkout.cart.items['CH1']).to eq(2)
    end

    it 'outputs an error message when an invalid product code is scanned' do
      expect { checkout.scan('XYZ') }.to output(/Invalid product code. Try again./).to_stdout
    end
  end

  describe '#add_product_option' do
    it 'adds a product option to the products hash' do
      checkout.add_product_option('CH1', 'Chai', 3.11)
      expect(checkout.products['CH1']).to be_a(Product)
    end
    it 'raises an error when invalid product options are passed' do
      expect { checkout.add_product_option(123, 'Chai', 3.11) }.to raise_error('Invalid Product Options')
    end
    it 'adds a product option with the correct attributes' do
      checkout.add_product_option('CH1', 'Chai', 3.11)
      expect(checkout.products['CH1'].code).to eq('CH1')
      expect(checkout.products['CH1'].name).to eq('Chai')
      expect(checkout.products['CH1'].price).to eq(3.11)
    end
  end
end
