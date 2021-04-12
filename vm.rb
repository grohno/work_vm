# 稼働例
# irb
# vm = VendingMachine.new   インスタンス化
# vm.slot_money (100)   お金を入れる
# vm.store    在庫追加
# vm.store_juice    在庫確認
# vm.choice   購入可能商品の照会
# vm.purchase('water')    水を購入
# vm.current_slot_money    現在の投入金額
# vm.sale_proceeds    売上
# vm.return_money   釣り銭返却


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
    @buttons = [{name: 'coke', price: 120, stock: 5}]
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
    puts @sale
  end

  # ジュースの情報を出力
  def store_juice
    puts @buttons
  end

  # ジュースを追加格納する
  def store
    @buttons << {name: 'Red Bull', price: 200, stock: 5}
    @buttons << {name: 'water', price: 100, stock: 5}
  end

  # 買えるもの表示し、商品を選択する
  def choice  #在庫の条件分岐を追加する
    # お金が200円以上で、すべての在庫がある場合
    if current_slot_money >= @buttons[1][:price] && @buttons[0][:stock] >= 1 && @buttons[1][:stock] >= 1 && @buttons[2][:stock] >= 1
      puts "0番：#{@buttons[0][:name]}, 1番：#{@buttons[1][:name]}, 2番：#{@buttons[2][:name]}の中からお選び頂けます。"
    # お金が120円以上で、コーラと水の在庫がある場合
    elsif current_slot_money >= @buttons[0][:price] && @buttons[0][:stock] >= 1 && @buttons[2][:stock] >= 1
      puts "0番：#{@buttons[0][:name]}, 2番：#{button[2][:name]}の中からお選び頂けます。"
    # お金が100円以上で、水の在庫がある場合
    elsif current_slot_money >= @buttons[2][:price] && @buttons[2][:stock] >= 1
      puts "2番：#{@buttons[2][:name]}のみお選び頂けます。"
    else
      # puts "購入金が不足しています。"    # 投入金額が足りない場合もしくは在庫がない場合、購入操作を行っても何もしない。
    end
  end

  # 購入する(引数にボタンの番号を入力)
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
