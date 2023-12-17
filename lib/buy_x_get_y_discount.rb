class BuyXGetYDiscount
  attr_reader :discount_type, :discount_code, :x_code, :x_quantity_needed, :y_discount, :y_code, :limit

  def initialize(discount_type, discount_code, x_code, x_quantity_needed, y_discount, y_code, limit = Float::INFINITY)
    @discount_type = discount_type
    @discount_code = discount_code
    @x_code = x_code
    @x_quantity_needed = x_quantity_needed
    @y_discount = y_discount
    @y_code = y_code
    @limit = limit
  end
end
