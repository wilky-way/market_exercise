require_relative 'product'
require_relative 'cart'

class Checkout
  attr_reader :cart, :products

  def initialize
    @cart = Cart.new
    @products = {}
  end

  # Main loop for the checkout process
  def start_checkout
    loop do
      puts 'Please enter the product code or "total": '
      input = gets.chomp
      break if input == 'exit'
      handle_input(input)
    end
  end

  # Add a product to the cart
  def scan(code)
    # Validate the input before adding it to the cart
    if @products.include?(code)
      puts '------------------------------------------'
      puts "Added #{@products[code].name} to your cart"
      puts '------------------------------------------'
      @cart.add_item(code)
    else
      puts 'Invalid product code. Try again.'
    end
  end

  # Add a new product option
  def add_product_option(code, name, price)
    # Validate the input
    raise 'Invalid Product Options' unless code.is_a?(String) && name.is_a?(String) && (price.is_a?(Float) || price.is_a?(Integer))

    @products[code] = Product.new(code, name, price)
  end

  private

  # Route commands to the appropriate method
  def handle_input(input)
    case input
    when 'total'
      @cart.print_total(@products)
    else
      scan(input)
    end
  end
end
