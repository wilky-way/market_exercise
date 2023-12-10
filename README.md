# The Farmer's Market

This is a checkout system for a farmer's market that sells 4 products. 

```
+--------------|--------------|---------+
| Product Code |     Name     |  Price  |
+--------------|--------------|---------+
|     CH1      |   Chai       |  $3.11  |
|     AP1      |   Apples     |  $6.00  |
|     CF1      |   Coffee     | $11.23  |
|     MK1      |   Milk       |  $4.75  |
+--------------|--------------|---------+
```

### There are currently 3 specials:
1. BOGO -- Buy-One-Get-One-Free Special on Coffee. (Unlimited)
2. APPL -- If you buy 3 or more bags of Apples, the price drops to $4.50.
3. CHMK -- Purchase a box of Chai and get milk free. (Limit 1)

# Getting Started
### Start the program by running the following command in the lib directory:

`ruby market.rb`

### Add items to the cart by entering a product code (AP1, CH1, etc.).
```
Please enter the product code or "total": 
MK1
```

### Calculate the total by entering the "total" command.
```
Please enter the product code or "total": 
total
Item                          Price
----                          -----
Milk                          $4.75
Milk                          $4.75
Chai                          $3.11
-----------------------------------
                             $12.61
```

