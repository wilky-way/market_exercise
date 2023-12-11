require_relative 'discounts'

class Cart
  attr_reader :items

  def initialize
    @items = {}
  end

  def add_item(code)
    @items[code] = 0 unless @items.include?(code)
    @items[code] += 1
  end

  # Initialize the discount class and calculate the total using the discounts
  def total(products)
    discounts = Discounts.new(products, @items)
    calculate_total(discounts, products)
  end

  # Calculate the total and print out the results
  def calculate_total(discounts, products)
    print_header
    total = 0
    @items.each do |code, quantity|
      quantity.times do
        puts "#{products[code].name.ljust(30)}#{"$#{format('%.2f', products[code].price)}".rjust(6)}"
        total += discounts.apply_discounts(code)
      end
    end
    print_total(total)
    total
  end

  def print_header
    puts 'Item                           Price'
    puts '----                           -----'
  end

  def print_total(total)
    puts '------------------------------------'
    puts format('%.2f', total).to_s.rjust(36)
  end
end