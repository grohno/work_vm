# 例
# irb
# require './work/vm.rb'
# （↑のパスは、自動販売機ファイルが入っているパスを指定する）
# 初期設定（自動販売機インスタンスを作成して、vmという変数に代入する）
# vm = VendingMachine.new
# 作成した自動販売機に100円を入れる
# vm.slot_money (100)
# 作成した自動販売機に入れたお金がいくらかを確認する（表示する）
# vm.current_slot_money
# 作成した自動販売機に入れたお金を返してもらう
# vm.return_money

class VendingMachine
  # ステップ０　お金の投入と払い戻しの例コード
  # ステップ１　扱えないお金の例コード
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  MONEY = [10, 50, 100, 500, 1000].freeze

  # （自動販売機に投入された金額をインスタンス変数の @slot_money に代入する）
  def initialize
    # 最初の自動販売機に入っている金額は0円
    @slot_money = 0

    # 最初の売上金額は0円
    @sale_proceeds = 0

    # ステップ２の要件1
    # 初期状態で、コーラ（値段:120円、名前”コーラ”）を5本格納している。
    @price = 120
    @name = 'コーラ'
    @store_juice = [
      {price: @price, name: @name},
      {price: @price, name: @name},
      {price: @price, name: @name},
      {price: @price, name: @name},
      {price: @price, name: @name}
    ]

    #在庫数
    @stock = @store_juice.length
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
    return false unless MONEY.include?(money)
    # 自動販売機にお金を入れる
    @slot_money += money
  end

  # ステップ0の要件4
  # 払い戻し操作を行うと、投入金額の総計を釣り銭として出力する。
  # ステップ3の要件5
  # 払い戻し操作では現在の投入金額からジュース購入金額を引いた釣り銭を出力する。
  def return_money
    # 返すお金の金額を表示する
    puts @slot_money
    # 自動販売機に入っているお金を0円に戻す
    @slot_money = 0
  end

  # ステップ２の要件2
  # 格納されているジュースの情報（値段と名前と在庫）を取得できる。
  def store_juice
    "値段: #{@price}円  名前: " + @name  + "  在庫: #{@stock}本"
  end

  # ステップ3の要件1
  # 投入金額、在庫の点で、コーラが購入できるかどうかを取得できる。
  def purchase
    # ステップ3の要件2
    # ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、ジュースの在庫を減らし、売り上げ金額を増やす。
    # ジュースの値段以上の投入金額が投入されていてかつ在庫がある場合
    if @slot_money >= 120 && @stock != 0
      # divmodメソッド　商と余りを配列で返す
      # quotientに商(買える本数)、remainderに余り(おつり)が返される
      quotient, remainder = @slot_money.divmod(@price)
      # もし買える本数が在庫より少なかったら？
      if quotient < @stock
        # 売上金額を増やす
        @sale_proceeds += quotient * @price
        # 残った投入金額の計算
        @slot_money = remainder
        # ジュースの在庫を減らす
        @stock -= quotient
      # もし買える本数が在庫と同じ、もしくは超えていたら？
      else
        # 売上金額を増やす（全部お買い上げ）
        @sale_proceeds += @stock * @price
        # 残った投入金額の計算
        @slot_money -= @stock * @price
        # 在庫を減らす（すっからかんになる）
        @stock = 0
      end
    # ステップ3の要件3
    # 投入金額が足りない場合もしくは在庫がない場合、購入操作を行っても何もしない。
    # そもそも投入金額がジュース1本分より少ない、もしくは在庫がなかったら
    else
      # 購入操作を行っても何もしない
    end
  end

  # ステップ3の要件4
  # 現在の売上金額を取得できる
  def current_sale_proceeds
    # 現在の売上金額を表示する
    @sale_proceeds
  end

end
