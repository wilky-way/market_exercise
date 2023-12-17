require_relative 'printer'
require_relative 'buy_x_get_y_discount'
require_relative 'bulk_discount'

class Discounts
  attr_reader :printer, :products, :cart, :bogo_flag, :chmk_count

  def initialize(products, cart)
    @printer = Printer.new
    @products = products
    @cart = cart

    # Key - product code
    # Value - BuyXGetYDiscount or BulkDiscount
    @discounts = {}

    # to track how many of the activation product we have
    # key = discount code
    @buy_x_get_y_off_current_quantity = {}

    # to track if we're under the limit
    # key = discount code
    @buy_x_get_y_off_current_usage = {}

    @bogo_flag = false
    @chmk_count = 0
  end

  # Apply discounts to the appropriate products
  def apply_discounts(code)
    case @discounts[code]&.discount_type
    when 'buy_x_get_y_off'
      buy_x_get_y_off(@discounts[code])
    when 'bulk'
      bulk_discount(@discounts[code])
    else
      if (@buy_x_get_y_off_current_quantity[code])
        @buy_x_get_y_off_current_quantity[code] += 1
      end
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

  def create_discount(discount_type, discount_code, discount_amount, quantity_needed, target_product_code = nil, limit = Float::INFINITY, activation_product_code = nil )
    if limit == 0
      limit = Float::INFINITY
    end
    if (discount_type == 'buy_x_get_y_off')
      # x - activation product code
      # y - target product code
      @discounts[target_product_code] = BuyXGetYDiscount.new(discount_type,discount_code, activation_product_code, quantity_needed, discount_amount, target_product_code, limit)
      @buy_x_get_y_off_current_quantity[activation_product_code] = 0
      @buy_x_get_y_off_current_usage[discount_code] = 0
    elsif (discount_type == 'bulk')
      @discounts[target_product_code] = BulkDiscount.new(discount_type, discount_code, quantity_needed, discount_amount, target_product_code)
    end
  end

  def buy_x_get_y_off(discount)
    price = @products[discount.y_code].price
    original_price = price
    if @buy_x_get_y_off_current_quantity[discount.x_code] >= discount.x_quantity_needed && @buy_x_get_y_off_current_usage[discount.discount_code] < discount.limit
      price *= (1 - discount.y_discount)
      price = price.round(2)
      # increment the current usage
      @buy_x_get_y_off_current_usage[discount.discount_code] += 1
      # reset the current quantity
      @buy_x_get_y_off_current_quantity[discount.x_code] = 0

      @printer.print_discount(discount.discount_code, original_price - price)
    else
      @buy_x_get_y_off_current_quantity[discount.x_code] += 1
    end
    price
  end

  def bulk_discount(discount)
    price = @products[discount.target_product_code].price
    original_price = price
    if @cart[discount.target_product_code] >= discount.quantity_needed
      price *= (1 - discount.discount_amount)
      @printer.print_discount(discount.discount_code, original_price - price)
    end
    price
  end
end
