class BulkDiscount
  attr_reader :discount_type, :discount_code, :quantity_needed, :discount_amount, :target_product_code

  def initialize(discount_type, discount_code, quantity_needed, discount_amount, target_product_code)
    @discount_type = discount_type
    @discount_code = discount_code
    @quantity_needed = quantity_needed
    @discount_amount = discount_amount
    @target_product_code = target_product_code
  end
end
