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

  # Main loop for the checkout process that routes commands to the appropriate methods
  def run
    puts 'Please enter the product code or "total": '
    input = gets.chomp
    while input != 'exit'
      case input
      when 'total'
        total
      else
        scan(input)
      end
      puts 'Please enter the product code or "total": '
      input = gets.chomp
    end
  end

  # Iterates through the cart and prints each item and it's price, followed by the total
  def total
    total = 0
    puts @cart
    puts "Item                          Price"
    puts "----                          -----"
    @cart.each do |code, quantity|
      total += @products[code].price * quantity
      quantity.times do
        puts "#{@products[code].name.ljust(30)}#{("$#{format('%.2f', @products[code].price)}").rjust(5)}"
      end
    end
    puts "-----------------------------------"
    puts "#{("$#{format('%.2f', total)}").rjust(35)}"
    # puts "total is $#{total}"
  end
end

