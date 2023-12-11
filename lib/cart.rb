require_relative 'discounts'

class Cart
  attr_reader :items

  def initialize
    @items = {}
  end

  # Add an item to the cart
  def add_item(code)
    @items[code] = 0 unless @items.include?(code)
    @items[code] += 1
  end

  # Initialize the discount class every time we print the total
  def print_total(products)
    discounts = Discounts.new(products, @items)
    print_header
    total = calculate_total(discounts, products)
    print_footer(total)
  end

  # Calculate the total and print out the results
  def calculate_total(discounts, products)
    total = 0
    @items.each do |code, quantity|
      quantity.times do
        # Print out the product name and original price
        puts "#{products[code].name.ljust(30)}#{"$#{format('%.2f', products[code].price)}".rjust(6)}"
        # Add the discounted price to the total and print out the discounts if applicable
        total += discounts.apply_discounts(code).to_f
      end
    end
    total
  end

  def print_header
    puts 'Item                           Price'
    puts '----                           -----'
  end

  def print_footer(total)
    puts '------------------------------------'
    puts format('%.2f', total).to_s.rjust(36)
  end
end