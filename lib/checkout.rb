require_relative 'product'
require_relative 'discount'

class Checkout
  attr_reader :cart

  def initialize
    @cart = {}
    @products = {}
  end

  # Add a new product option
  def add_product_option(code, name, price)
    @products[code] = Product.new(code, name, price)
  end

  # Add a product to the cart
  def scan(code)
    if @products.include?(code)
      puts '------------------------------------------'
      puts "Added #{@products[code].name} to your cart"
      puts '------------------------------------------'
      @cart[code] = 0 unless @cart.include?(code)
      @cart[code] += 1
    else
      puts 'Invalid product code. Try again.'
    end
  end

  # Main loop for the checkout process
  def run
    loop do
      puts 'Please enter the product code or "total": '
      input = gets.chomp
      break if input == 'exit'
      handle_input(input)
    end
  end

  private
  
  # Route commands to the appropriate method
  def handle_input(input)
    case input
    when 'total'
      total
    else
      scan(input)
    end
  end

  # Initialize the discount class and calculate the total using the discounts
  def total
    discount = Discount.new(@products, @cart)
    calculate_total(discount)
  end

  # Calculate the total and print out the results
  def calculate_total(discount)
    print_header
    total = 0
    @cart.each do |code, quantity|
      quantity.times do
        puts "#{@products[code].name.ljust(30)}#{"$#{format('%.2f', @products[code].price)}".rjust(6)}"
        total += discount.apply_discounts(code)
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
