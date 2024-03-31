# Problem

Coding Challenge: Store checkout
Store sells 3 products: Code | Name | Price
1. VOUCHER | Voucher | 5.00 $
2. TSHIRT | T-Shirt | 20.00 $
3. MUG | Coffee Mug | 7.50 $

There can be discounts/pricing rules for a product. Ideally your code should have the ability to add multiple pricing rules for a product but only the best should apply.
An example of rules:
2-for-1 promotions (buy two of the same product, get one free), and would like for there to be a 2-for-1 special on VOUCHER items.
There can also be discounts on bulk purchases (buying x or more of a product, the price of that product is reduced), and demands that if you buy 3 or more TSHIRT
items, the price per unit should be 19.00 $.
Your code should be able to cater at least these 2 type of rules with configurable values. For eg. instead of 2 for 1, we can make 3 for 1 or 5 for 2 offers as well or for
4 shirts, price of each tshirt becomes 15$ and similar.
Checkout process allows for items to be scanned in any order, and should return the total amount to be paid. The interface for the checkout process may look like
this (ruby):

```bash
  co = Checkout.new
  co.scan("VOUCHER")
  co.scan("VOUCHER")
  co.scan("TSHIRT")
  price = co.total
```
This is just an example, you can have your own class and method names, your own way to do it.
Plain ruby implementation is preferable than Rails. But it can be done as a rails project as well if you are not comfortable with plain ruby implementation.
Products should be configurable with a JSON file. It can be added as seed data if Rails being used
Examples based on above pricing rules:
1. Items: VOUCHER, TSHIRT, MUG
Total: 32.50 $
2. Items: VOUCHER, TSHIRT, VOUCHER
Total: 25.00 $
3. Items: TSHIRT, TSHIRT, TSHIRT, VOUCHER, TSHIRT
Total: 81.00 $
4. Items: VOUCHER, TSHIRT, VOUCHER, VOUCHER, MUG, TSHIRT, TSHIRT
Total: 74.50 $

The code submission should:
1. Demonstrate OOP
2. Be easy to grow and easy to add new functionality.
3. Clean, minimal, well-designed code
4. Have a Readme file explaining the setup to run the solution and tests and why certain things are included and others are left out if any.
5. Bonus - Test cases
6. No 3rd party gems etc to be used apart from maybe test cases.

# Checkout Application

This is a simple checkout application that calculates the total price of items based on pricing rules and discounts.

## Functionality

The application supports the following functionality:

- Loading pricing rules from a JSON file.
- Scanning items and adding them to the cart.
- Calculating the total price, considering any applicable discounts.

## Usage

### Running the Application

To run the application, follow these steps:

1. Make sure you have Ruby installed on your system.
2. Clone this repository.
3. Navigate to the project directory in your terminal.
4. Make sure you have `rules.json` file containing pricing rules.
5. Run the following command:

```bash
  ruby example_usage.rb
```


6. Follow the prompt to enter the items to be scanned, separated by commas.
Example:-
```bash
  Enter the items to scan (separated by comma):
  Example:- TSHIRT, VOUCHER, MUG
  TSHIRT, TSHIRT, TSHIRT, VOUCHER, TSHIRT
```
7. The application will display the total price.
```bash
  Total: 81.0 $
```

### Store Checkout Rakefile

This Rakefile provides a set of tasks to manage products, discounts, and prices in a store checkout system. It utilizes Ruby's Rake tool to define and execute tasks conveniently from the command line.

### Commands and Usage

Adds a new product to the store.

Usage:
```bash
rake add_product
```
Follow the prompts to input the product name, price, and optional discount details.

Removes an existing product from the store.

Usage:
```bash
rake remove_product
```
Follow the prompts to select the product to be removed from the available list.

Adds a discount to an existing product.

Usage:
```bash
rake add_discount
```
Follow the prompts to input the product name and the type of discount to be added (e.g., bulk discount, 2-for-1 deals).

Removes a discount from an existing product.

Usage:
```bash
rake remove_discount
```
Follow the prompts to input the product name and select the discount to be removed from the available list.

Modifies the price of an existing product.

Usage:
```bash
rake modify_price
```
Follow the prompts to input the product name and the new price for the product.

### Running the Test Cases

To run the test cases for the application, follow these steps:

1. Make sure you have RSpec installed by using command
```bash
  bundle install
```
2. Navigate to the project directory in your terminal.
3. Run the following command:
```bash
  rspec
```