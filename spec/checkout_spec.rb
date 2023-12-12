require_relative '../lib/checkout'
require_relative '../lib/product'
require_relative '../lib/cart'
require_relative '../lib/printer'

describe Checkout do
  let(:checkout) { Checkout.new }
  let(:cart) { Cart.new }
  let(:printer) { Printer.new }
  let(:products) do
    {
      'CH1' => Product.new('CH1', 'Chai', 3.11),
      'AP1' => Product.new('AP1', 'Apples', 6.00),
      'CF1' => Product.new('CF1', 'Coffee', 11.23),
      'MK1' => Product.new('MK1', 'Milk', 4.75)
    }
  end

  describe '#initialize' do
    it 'initializes a new cart' do
      expect(checkout.cart).to be_a(Cart)
    end
    it 'initializes a new printer' do
      expect(checkout.printer).to be_a(Printer)
    end
    it 'initializes an empty products hash' do
      expect(checkout.products).to eq({})
    end
  end

  describe '#start_checkout' do
    it 'prompts the user to enter a product code or total' do
      # Read AP1 from gets and then exit
      allow(checkout).to receive(:gets).and_return('AP1', 'exit')
      $stdout = StringIO.new
      checkout.start_checkout
      $stdout.rewind
      expect($stdout.gets).to eq("Please enter the product code or 'total': \n")
    end
    it 'calls the handle_input method with AP1 as user input' do
      # Read AP1 from gets and then exit
      allow(checkout).to receive(:gets).and_return('AP1', 'exit')
      expect(checkout).to receive(:handle_input)
      checkout.start_checkout
    end
    it 'breaks the loop and exits when the user enters "exit"' do
      # Read exit from gets
      allow(checkout).to receive(:gets).and_return('exit')
      expect(checkout).not_to receive(:handle_input)
      checkout.start_checkout
    end
  end

  describe '#scan' do
    it 'adds an item to the cart' do
      checkout.add_product_option('CH1', 'Chai', 3.11)
      checkout.scan('CH1')
      expect(checkout.cart.items['CH1']).to eq(1)
    end
    it 'outputs an error message when an invalid product code is scanned' do
      $stdout = StringIO.new
      checkout.scan('XYZ')
      $stdout.rewind
      expect($stdout.gets).to eq("Invalid product code. Try again.\n")
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
  describe '#handle_input' do
    it 'calls the scan method when the input is a product code' do
      expect(checkout).to receive(:scan).with('AP1')
      checkout.handle_input('AP1')
    end
    it 'calls the print_receipt method when the input is "total"' do
      expect(checkout.printer).to receive(:print_receipt)
      checkout.handle_input('total')
    end
  end
end
