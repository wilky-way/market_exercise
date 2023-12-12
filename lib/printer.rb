require_relative 'discounts'

class Printer
  # Print out the receipt and caclulate the total
  def print_receipt(products, items)
    print_header
    total = calculate_total(products, items)
    print_footer(total)
    total
  end

  # Calculate the total and print out the results
  def calculate_total(products, items)
    discounts = Discounts.new(products, items)
    total = 0

    items.each do |code, quantity|
      quantity.times do
        # Print out the product name and original price
        print_original_price(products[code].name, products[code].price)
        # Add the discounted price to the total and print discount
        total += discounts.apply_discounts(code).to_f
      end
    end
    total
  end

  def print_add_item(item_name)
    puts '------------------------------------------'
    puts "Added #{item_name} to your cart"
    puts '------------------------------------------'
  end

  def print_header
    puts 'Item                           Price'
    puts '----                           -----'
  end

  def print_original_price(name, price)
    puts "#{name.ljust(30)}#{"$#{format('%.2f', price)}".rjust(6)}"
  end

  def print_discount(discount_code, price)
    puts "#{discount_code.center(29)}#{format('-$%.2f', price).rjust(7)}"
  end

  def print_footer(total)
    puts '------------------------------------'
    puts format('$%.2f', total).to_s.rjust(36)
  end
end