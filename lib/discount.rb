class Discount
  def initialize(products, cart)
    @products = products
    @cart = cart
    @bogo_flag = false
    @chmk_count = 0
  end

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

  private

  def bogo(code)
    price = @products[code].price
    if @bogo_flag == true
      puts "            BOGO             -$#{format('%.2f', price)}"
      price = 0
    end
    @bogo_flag = !@bogo_flag
    price
  end

  def appl(code, quantity)
    price = @products[code].price
    if quantity >= 3
      puts '            APPL              -$1.50'
      price - 1.50
    else
      price
    end
  end

  def chmk(code)
    price = @products[code].price
    if @cart['CH1']&.positive? && @chmk_count == 0
      @chmk_count += 1
      puts "            CHMK              -$#{price}"
      0
    else
      price
    end
  end
end
