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

redbull = Drink.redbull
water = Drink.water

# 在庫管理
class Store
  attr_accessor :stocklist
  def initialize
    @stocklist = []
    stock_juice(Drink.coke, 5)
  end
  # ジュースを追加格納する
  def stock_juice(drink, num)
    hash = {name: drink.name, price: drink.price, stock: num}
    @stocklist.push(hash)
  end
end

store = Store.new
store.stock_juice(redbull, 5)
store.stock_juice(water, 5)

# お金の増減管理
class Cashier
  MONEY = [10, 50, 100, 500, 1000].freeze
  def initialize
    #一時的に入ってるキャッシュトレー
    @slot_money = 0
    #確定キャッシュトレー
    @sale = 0
  end
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  # 投入は複数回できる。
  def insert(money)
    # 想定外のもの（１円玉や５円玉。千円札以外のお札、そもそもお金じゃないもの（数字以外のもの）など）
    # が投入された場合は、投入金額に加算せず、それをそのまま釣り銭としてユーザに出力する。
    return puts money unless MONEY.include?(money)
    # 自動販売機にお金を入れる(slot_moneyに有効値を追加していく)
    @slot_money += money
  end
  # 投入金額の総計を取得できる。
  def current_slot_money
    # 自動販売機に入っているお金を表示する
    @slot_money
  end
  # 払い戻し操作を行うと、投入金額の総計を釣り銭として出力する。
  def return_money
    # 返すお金の金額を表示する
    puts @slot_money
    # 自動販売機に入っているお金を0円に戻す
    @slot_money = 0
  end
  # 売上を表示する
  def sale_proceeds
    @sale
  end
end

cashier = Cashier.new

# 表示
class Display
  # 格納されているジュースの情報（値段と名前と在庫）を取得できる。
  def initialize(store, cashier)
    @buttons = store.stocklist
    @cashier = cashier
  end
  def store_juice
    puts @buttons
  end
  # 購入可能なドリンクの取得
  def choice
    texts = []
    @buttons.length.times do |i|
      if @buttons[i][:stock] == 0
        # ↓ 最終的にはコメントアウト？
        puts "#{i}番：#{@buttons[i][:name]} は売り切れです"
      end
      if @buttons[i][:stock] != 0
        if @cashier.current_slot_money >= @buttons[i][:price]
          texts << "#{i}番：#{@buttons[i][:name]}"
        end
      end
    end
    if @cashier.current_slot_money != 0 && texts.length != 0
      # ↓ 最終的にはコメントアウト？
      puts "現在の金額では #{texts.join(' 、')}をご購入いただけます"
      texts
    else
      # ↓ 最終的にはコメントアウト？
      puts "購入金が不足しています"
    end
  end
end

display = Display.new(store, cashier)

# 各クラスの統合・選択し購入する
class VendingMachine
  def initialize(store, cashier)
    @buttons = store.stocklist
    @cashier = cashier
    @slot_money = cashier.current_slot_money
    @sale = cashier.sale_proceeds
  end
  # 購入する(引数にボタンの番号を入力)
  def purchase(button)
    if @buttons[button][:stock] >= 1
      if @cashier.current_slot_money >= @buttons[button][:price]
        @slot_money -= @buttons[button][:price]
        @buttons[button][:stock] -= 1
        @sale += @buttons[button][:price]
        # ↓ 最終的にはコメントアウト？
        puts "#{@buttons[button][:name]}を購入しました"
        # ステップ5の、
        # 「ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、
        # 釣り銭（投入金額とジュース値段の差分）を出力する。」の要件に沿って
        # 現段階の残額を返す
        @slot_money
      else
        # ↓ 最終的にはコメントアウト？
        puts "購入金が不足しています。"
      end
    else
      # ↓ 最終的にはコメントアウト？
      puts "この商品は売り切れです"
    end
  end
end

vm = VendingMachine.new(store, cashier)
