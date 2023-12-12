require_relative 'printer'

class Discounts
  attr_reader :printer, :products, :cart, :bogo_flag, :chmk_count
  
  def initialize(products, cart)
    @printer = Printer.new
    @products = products
    @cart = cart
    @bogo_flag = false
    @chmk_count = 0
  end

  # Apply discounts to the appropriate products
  def apply_discounts(code)
    case code
    when 'CF1'
      bogo(code)
    when 'AP1'
      appl(code, @cart[code])
    when 'MK1'
      chmk(code)
    else
      @products[code].price
    end
  end

  # Buy-One-Get-One-Free Special on Coffee. (Unlimited)
  def bogo(code)
    price = @products[code].price
    if @bogo_flag == true
      @printer.print_discount('BOGO', price)
      price = 0
    end
    @bogo_flag = !@bogo_flag
    price
  end

  # If you buy 3 or more bags of Apples, the price drops to $4.50
  def appl(code, quantity)
    price = @products[code].price
    if quantity >= 3
      @printer.print_discount('APPL', 1.50)
      price -= 1.50
    end
    price
  end

  # Purchase a box of Chai and get milk free. (Limit 1)
  def chmk(code)
    price = @products[code].price
    if @cart['CH1']&.positive? && @chmk_count.zero?
      @chmk_count += 1
      @printer.print_discount('CHMK', price)
      price = 0
    end
    price
  end
end
