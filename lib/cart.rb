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

end
