require_relative '../lib/product'
require_relative '../lib/printer'

describe Printer do
  let(:printer) { Printer.new }
  let(:products) do
    {
      'CH1' => Product.new('CH1', 'Chai', 3.11),
      'AP1' => Product.new('AP1', 'Apples', 6.00),
      'CF1' => Product.new('CF1', 'Coffee', 11.23),
      'MK1' => Product.new('MK1', 'Milk', 4.75)
    }
  end
  describe '#print_receipt' do
    it 'prints the items, discounts, and total in the correct format' do
      items = { 'CH1' => 1, 'AP1' => 1, 'CF1' => 1, 'MK1' => 1 }
      $stdout = StringIO.new
      printer.print_receipt(products, items)
      $stdout.rewind
      expect($stdout.gets).to eq("Item                           Price\n")
      expect($stdout.gets).to eq("----                           -----\n")
      expect($stdout.gets).to eq("Chai                           $3.11\n")
      expect($stdout.gets).to eq("Apples                         $6.00\n")
      expect($stdout.gets).to eq("Coffee                        $11.23\n")
      expect($stdout.gets).to eq("Milk                           $4.75\n")
      expect($stdout.gets).to eq("            CHMK              -$4.75\n")
      expect($stdout.gets).to eq("------------------------------------\n")
      expect($stdout.gets).to eq("                              $20.34\n")
    end
  end

  describe '#calculate_total' do
    it 'returns the total cost of the cart' do
      items = { 'CH1' => 1, 'AP1' => 1}
      expect(printer.calculate_total(products, items)).to eq(9.11)
    end
    it 'passes test case 1' do
      items = { 'CH1' => 1, 'AP1' => 1, 'CF1' => 1, 'MK1' => 1 }
      expect(printer.calculate_total(products, items)).to eq(20.34)
    end
    it 'passes test case 2' do
      items = { 'MK1' => 1, 'AP1' => 1 }
      discounts = Discounts.new(products, items)
      expect(printer.calculate_total(products, items)).to eq(10.75)
    end
    it 'passes test case 3' do
      items = { 'CF1' => 2 }
      expect(printer.calculate_total(products, items)).to eq(11.23)
    end
    it 'passes test case 4' do
      items = { 'AP1' => 3, 'CH1' => 1 }
      expect(printer.calculate_total(products, items)).to eq(16.61)
    end
    it 'passes test case 5' do
      items = { 'CF1' => 5, 'AP1' => 5, 'CH1' => 4, 'MK1' => 3 }
      expect(printer.calculate_total(products, items)).to eq(78.13)
    end
  end

  describe '#print_add_item' do
    it 'prints a message with the item name inside' do
      $stdout = StringIO.new
      printer.print_add_item('Chai')
      $stdout.rewind
      expect($stdout.gets).to eq("------------------------------------------\n")
      expect($stdout.gets).to eq("Added Chai to your cart\n")
      expect($stdout.gets).to eq("------------------------------------------\n")
    end
  end

  describe '#print_header' do
    it 'prints the header with Item and Price and a bottom border' do
      $stdout = StringIO.new
      printer.print_header
      $stdout.rewind
      expect($stdout.gets).to eq("Item                           Price\n")
      expect($stdout.gets).to eq("----                           -----\n")
    end
  end

  describe '#print_original_price' do
    it 'prints the original price of the item' do
      $stdout = StringIO.new
      printer.print_original_price('Chai', 3.11)
      $stdout.rewind
      expect($stdout.gets).to eq("Chai                           $3.11\n")
    end
  end

  describe '#print_discount' do
    it 'prints the discount code and the amount discounted' do
      $stdout = StringIO.new
      printer.print_discount('CHMK', 4.75)
      $stdout.rewind
      expect($stdout.gets).to eq("            CHMK              -$4.75\n")
    end
  end

  describe '#print_footer' do
    it 'prints out the cart total with a divider above' do
      $stdout = StringIO.new
      printer.print_footer(20.34)
      $stdout.rewind
      expect($stdout.gets).to eq("------------------------------------\n")
      expect($stdout.gets).to eq("                              $20.34\n")
    end
  end
end