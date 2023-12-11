require_relative 'lib/checkout'

# Create a new checkout instance
checkout = Checkout.new

# Add product options
checkout.add_product_option('CH1', 'Chai', 3.11)
checkout.add_product_option('AP1', 'Apples', 6.00)
checkout.add_product_option('CF1', 'Coffee', 11.23)
checkout.add_product_option('MK1', 'Milk', 4.75)

# Start the checkout process
checkout.start_checkout
