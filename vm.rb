# 稼働例
# irb
# vm = VendingMachine.new   インスタンス化
# vm.slot_money (100)   お金を入れる
# vm.store(Drink.redbull, 5)  在庫追加(レッドブルを5本)
# vm.store(Drink.water, 5)  在庫追加(水を5本)
# vm.store_juice    在庫確認
# vm.choice   購入可能商品の照会
# vm.purchase(2)    水を購入
# vm.current_slot_money    現在の投入金額
# vm.sale_proceeds    売上
# vm.return_money   釣り銭返却

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
  def hash
    hash = {name: @name, price: @price}
  end
end

class VendingMachine
  # ステップ０　お金の投入と払い戻しの例コード
  # ステップ１　扱えないお金の例コード
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  MONEY = [10, 50, 100, 500, 1000].freeze
  # （自動販売機に投入された金額をインスタンス変数の @slot_money に代入する）

  def initialize
    # 最初の自動販売機に入っている金額は0円
    @slot_money = 0
    # 品揃え、値段、在庫の初期設定
    coke = Drink.new(120, 'coke')
    cokehash = coke.hash
    cokehash[:stock] = 5
    @buttons = [cokehash]
    # 売上を格納する変数の初期設定
    @sale = 0
  end

  # 投入金額の総計を取得できる。
  def current_slot_money
    # 自動販売機に入っているお金を表示する
    @slot_money
  end

  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  # 投入は複数回できる。
  def slot_money(money)
    # 想定外のもの（１円玉や５円玉。千円札以外のお札、そもそもお金じゃないもの（数字以外のもの）など）
    # が投入された場合は、投入金額に加算せず、それをそのまま釣り銭としてユーザに出力する。
    return puts money unless MONEY.include?(money)
    # 自動販売機にお金を入れる(slot_moneyに有効値を追加していく)
    @slot_money += money
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

  # ジュースの情報を出力
  def store_juice
    @buttons
  end

  # ジュースを追加格納する
  def store(drink, num)
    match_button = @buttons.find { |button| button[:name] == drink.name}
    if match_button
      match_button[:stock] += num
    else
      hash = {name: drink.name, price: drink.price, stock: num}
      @buttons << hash
    end
  end

  # 買えるもの表示し、商品を選択する
  def choice
    texts = []
    @buttons.length.times do |i|
      if @buttons[i][:stock] == 0
        # ↓ 最終的にはコメントアウト？
        puts "#{i}番：#{@buttons[i][:name]} は売り切れです"
      end
      if (@buttons[i][:stock] != 0) && (current_slot_money >= @buttons[i][:price])
        texts << "#{i}番：#{@buttons[i][:name]}"
      end
    end
    if current_slot_money != 0 && texts.length != 0
      # ↓ 最終的にはコメントアウト？
      puts "現在の金額では #{texts.join(' 、')}をご購入いただけます"
      texts
    else
      # ↓ 最終的にはコメントアウト？
      puts "購入金が不足しています"
    end
  end

  # 購入する(引数にボタンの番号を入力)
  def purchase(button)
    if @buttons[button][:stock] >= 1
      if current_slot_money >= @buttons[button][:price]
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
