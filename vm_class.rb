# ジュースの属性定義
class Drink
  attr_reader :name, :price
  def self.coke
    self.new 120, :coke
  end
  def self.redbull
    self.new 200, :red_bull
  end
  def self.water
    self.new 100, :water
  end
  def initialize price, name
    @name = name
    @price = price
  end
end

# 在庫管理
class Store
  def initialize
    @stocklist = []
    stock_juice(Drink.coke, 5)
  end
  # ジュースを追加格納する
  def stock_juice(drink, num)
    hash = {name: drink.name, price: drink.price, stock: num}
    @stocklist.push(hash)
  end
  def stock
    @stocklist
  end
end


# お金の増減管理
class Cashier
  MONEY = [10, 50, 100, 500, 1000].freeze
  def initialize
    @buttons = Store.stock
    #一時的に入ってるキャッシュトレー
    @slot_money = slot_money = 0
    #確定キャッシュトレー
    @sale = 0
  end
  def insert(money)
    return puts money unless MONEY.include?(money)
    @slot_money += money
  end
  def current_slot_money
    @slot_money
  end
  def return_money
    puts @slot_money
    @slot_money = 0
  end
  def sale_proceeds
    puts @sale
  end
  def purchase(button)
    if @buttons[button][:stock] >= 1
      if current_slot_money >= @buttons[button][:price]
        @slot_money -= @buttons[button][:price]
        @buttons[button][:stock] -= 1
        @sale += @buttons[button][:price]
        puts "#{@buttons[button][:name]}を購入しました"
      else
        puts "購入金が不足しています。"
      end
    else
      puts "この商品は売り切れです"
    end
  end
end


# 表示
class Display
  # 格納されているジュースの情報（値段と名前と在庫）を取得できる。
  def initialize
    @buttons = Store.stock
    @cashier = Cashier.new
  end
  def store_juice
    puts @buttons
  end
  # 購入可能なドリンクの取得
  def choice
    texts = []
    @buttons.length.times do |i|
      if @buttons[i][:stock] == 0
        puts "#{i}番：#{@buttons[i][:name]} は売り切れです"
      end
      if @buttons[i][:stock] != 0
        if @cashier.current_slot_money >= @buttons[i][:price]
          texts << "#{i}番：#{@buttons[i][:name]} "
        end
      end
    end
    if @cashier.current_slot_money != 0 || texts.length != 0
      puts "現在の金額では #{texts.join('、')}をご購入いただけます"
    else
      puts "購入金が不足しています"
    end
  end
end


# 各クラスの統合・選択し購入する
class VendingMachine
  def initialize
    @store = Store.new
    @display = Display.new
    @cashier = Cashier.new
  end
  def stock_juice(drink, num)
    @store.stock_juice(drink, num)
  end
  def store_juice
    @display.store_juice
  end
  def choice
    @display.choice
  end
  def insert(money)
    @cashier.insert(money)
  end
  def current_slot_money
    @cashier.current_slot_money
  end
  def return_money
    @cashier.return_money
  end
  def sale_proceeds
    @cashier.sale_proceeds
  end
  def purchase(button)
    @cashier.purchase(button)
  end
end
