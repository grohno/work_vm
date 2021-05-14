# 稼働例
# irb
# require '/Users/ryosuke.f/workspace/work_vm/vm.rb'
# vm = VendingMachine.new      インスタンス化
# vm.insert_money(money)        お金を入れる　★適正値意外にnillを返したい
# vm.slot_money                現在の投入金額
# vm.return_money              投入金額返却
# vm.store(Drink.red_bull, 5)  在庫追加(レッドブルを5本)
# vm.store(Drink.water, 5)     在庫追加(水を5本)
# vm.store_info                在庫確認
# vm.purchased_list            購入可能商品の照会
# vm.purchase(2)               水を購入 ★引数をnameにしたい
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
    @slot_money
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
    else
      @drink = Drink.drink.hash
      @buttons << @drink
    end
  end

  def purchased_list        # choice
    # texts = []
    @buttons.each do |i|
      # if @buttons[i][:stock] == 0
        # puts "#{i}番：#{@buttons[i][:name]} は売り切れです"
      # end
      if ( i[:stock] != 0 ) && ( @slot_money >= i[:price] )
       p i[:name]
      end
    end
    # if current_slot_money != 0 && texts.length != 0
      # puts "現在の金額では #{texts.join(' 、')}をご購入いただけます"
      # texts
    # else
      # puts "購入金が不足しています"
    # end
  end

  def purchase(button)
    if ( @buttons[button][:stock] >= 1 ) && ( @slot_money >= @buttons[button][:price] )
        @slot_money -= @buttons[button][:price]
        @buttons[button][:stock] -= 1
        @sale += @buttons[button][:price]
        # puts "#{@buttons[button][:name]}を購入しました"
        @slot_money
      # else
        # puts "購入金が不足しています。"
      # end
    # else
      # puts "この商品は売り切れです"
    end
  end
end
