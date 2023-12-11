require_relative 'product'
require_relative 'cart'

class Checkout
  attr_reader :cart

  def initialize
    @cart = Cart.new
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
      @cart.add_item(code)
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
      @cart.total(@products)
    else
      scan(input)
    end
  end
end
