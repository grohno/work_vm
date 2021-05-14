# 稼働例
# irb
# require '/Users/ryosuke.f/workspace/work_vm/vm.rb'
# vm = VendingMachine.new      インスタンス化
# vm.insert_money(money)        お金を入れる　★適正値意外にnillを返したい
# vm.slot_money                現在の投入金額
# vm.return_money              投入金額返却
# vm.store(red_bull, 5)  在庫追加(レッドブルを5本)
# vm.store(water, 5)     在庫追加(水を5本)
# vm.store_info                在庫確認
# vm.purchased_list            購入可能商品の照会
# vm.purchase(name)               水を購入 ★引数をnameにしたい
# vm.sale_proceeds             売上金

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
    @slot_money
    @slot_money = 0
  end
  def sale_proceeds
    @sale
  end

  def store_info
    @buttons
  end
  def store_stock(name, num)
    match_button = @buttons.find { |button| button == Drink.name}.hash
    if match_button
      match_button[:stock] += num
    else
      name = match_button
      @buttons << name
    end
  end
  def purchased_list
    @buttons.each do |button|
      if ( button[:stock] != 0 ) && ( @slot_money >= button[:price] )
        button[:name]
      end
    end
  end
  def purchase(name)
    match_button = @buttons.find { |button| button == Drink.name}
    if ( match_button[:stock] >= 1 ) && ( @slot_money >= match_button[:price] )
      @slot_money -= match_button[:price]
      match_button[:stock] -= 1
      @sale += match_button[:price]
      p @slot_money
    end
  end
end
