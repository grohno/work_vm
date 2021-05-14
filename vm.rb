# 稼働例
# irb
# vm = VendingMachine.new
# vm.insert_money(100)
# vm.insert_money(80)
# vm.slot_money
# vm.return_money
# vm.store(Drink.red_bull, 5)
# vm.store(Drink.water, 5)
# vm.purchased_list
# vm.purchase(:coke)
# vm.purchase(:red_bull)
# vm.purchase(:rwater)
# vm.sale_proceeds

class Drink
  attr_reader :name, :price
  def self.coke
    self.new 120, :coke
  end
  def self.red_bull
    self.new 200, :red_bull
  end
  def self.water
    self.new 100, :water
  end

  def initialize price, name
    @name = name
    @price = price
  end
  def hash
    hash = {name: @name, price: @price}
  end
end

class VendingMachine
  MONEY = [10, 50, 100, 500, 1000].freeze
  def initialize
    @slot_money = 0
    @sale = 0
    @buttons = []
    @coke = Drink.coke.hash
    # cokehash = coke.hash
    @coke[:stock] = 5
    @buttons << @coke
  end

  def slot_money
    @slot_money
  end
  def insert_money(money)
    return puts money unless MONEY.include?(money)
    @slot_money += money
  end
  def return_money
    puts @slot_money
    @slot_money = 0
  end
  def sale_proceeds
    @sale
  end

  def store_info
    @buttons
  end

  def store(drink, num)
    match_button = @buttons.find { |button| button[:name] == drink.name}
    if match_button
      match_button[:stock] += num
      puts @buttons
    else
      hash = {name: drink.name, price: drink.price, stock: num}
      @buttons << hash
    end
  end

  def purchased_list
    texts = []
    @buttons.each do |i|
      if ( i[:stock] != 0 ) && ( @slot_money >= i[:price] )
        texts << i[:name]
      end
    end
    texts
  end

  def purchase(name)
    match_button = @buttons.find { |button| button[:name] == name}
    if ( match_button[:stock] >= 1 ) && ( @slot_money >= match_button[:price] )
        @slot_money -= match_button[:price]
        match_button[:stock] -= 1
        @sale += match_button[:price]
        @slot_money
    end
  end
end
