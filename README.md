# グループワーク 自動販売機-VendingMachine

## 要件
- irb実行で動かせるようにする（NG：rubyファイル名で実行しない）

## ルールURL

<a href="http://devtesting.jp/tddbc/?TDDBC%E5%A4%A7%E9%98%AA3.0/%E8%AA%B2%E9%A1%8C" target="_blank">自動販売機ルールページへ<a>

## 要件チェックシート

<a href="https://docs.google.com/spreadsheets/d/159EDG4ju9EHbTV2rLLa0mjtw8iWaym_zZogciinaqRM/edit?usp=sharing" target="_blank">Googleスプレッドシートへ<a>

## テスト駆動開発（TDD）とは？
- 私自身がよくわかってなかったのでメモです

> テスト駆動開発（Test-Driven Development: TDD）とは、テストファーストなプログラムの開発手法です。 つまり、プログラムの実装前にテストコードを書き（テストファースト）、そのテストコードに適合するように実装とリファクタリングを進めていく方法を指します。

<a href="https://www.qbook.jp/column/20181009_713.html" target="_blank">Qbookジャーナルの該当記事へ<a>



## 課題要件に係るメソッド

**インスタンス化**

**ステップ2：**
値段と名前の属性からなるジュースを１種類格納できる。
初期状態で、コーラ（値段:120円、名前”コーラ”）を5本格納している。

```ruby
vm = VendingMachine.new
```


**ステップ0：**
10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
投入は複数回できる。

**ステップ1：**
想定外のもの（硬貨：１円玉、５円玉。お札：千円札以外のお札）が投入された場合は、投入金額に加算せず、それをそのまま釣り銭としてユーザに出力する。**

```ruby
vm.insert_money(100)
vm.insert_money(80)
```


**ステップ0：**
投入金額の総計を取得できる。

```ruby
vm.slot_money
```


**ステップ0：**
払い戻し操作を行うと、投入金額の総計を釣り銭として出力する。

**ステップ3：**
払い戻し操作では現在の投入金額からジュース購入金額を引いた釣り銭を出力する。

```ruby
vm.return_money
```


**ステップ2：**
格納されているジュースの情報（値段と名前と在庫）を取得できる。

```ruby
vm.store_info
```


**ステップ4：**
ジュースを3種類管理できるようにする。
在庫にレッドブル（値段:200円、名前”レッドブル”）5本を追加する。
在庫に水（値段:100円、名前”水”）5本を追加する。

```ruby
vm.store_stock(Drink.coke, 5)
vm.store_stock(Drink.red_bull, 5)
vm.store_stock(Drink.water, 5)
```


**ステップ3：**
投入金額、在庫の点で、コーラが購入できるかどうかを取得できる。

**ステップ4：**
投入金額、在庫の点で購入可能なドリンクのリストを取得できる。

```ruby
vm.purchased_list
```


**ステップ3：**
ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、ジュースの在庫を減らし、売り上げ金額を増やす。

**ステップ5：**
ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、釣り銭（投入金額とジュース値段の差分）を出力する。
ジュースと投入金額が同じ場合、つまり、釣り銭0円の場合も、釣り銭0円と出力する。

```ruby
vm.purchase(:coke)
vm.purchase(:red_bull)
vm.purchase(:rwater)
```

**ステップ3：**
投入金額が足りない場合もしくは在庫がない場合、購入操作を行っても何もしない。

```ruby
vm.purchase(:coke)
vm.purchase(:red_bull)
vm.purchase(:water)
```

**ステップ3：**
現在の売上金額を取得できる。

```ruby
vm.sale_proceeds
```
