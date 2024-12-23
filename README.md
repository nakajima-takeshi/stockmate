# サービス名:StockMate
## サービス概要
- 登録された日用品の消耗具合を予測して、減ってきたタイミングで通知してくれます。
- 通知をLINE履歴で確認できるので、「何買えばいいんだっけ？」とわからなくなることを防具ことができます。
## 開発背景
一人暮らしをしていると、以下のようなシチュエーションがありました。

普段使っているシャンプーの残量が少なくなってきていることに気づき、次の日の仕事帰りに買おうと考えていた。
しかし次の日、そのことを忘れてしまっており、また少なくなってきた時に在庫がないことに気づいた。
それ以外にも日用品をまとめて購入しようと考え、休日にその他の日用品をまとめて購入に行ったのだが、帰宅後にシャンプーを買い忘れていることに気づき、もう一度買いに戻る羽目になった。

このように***日用品の買い忘れ***や***次はいつ、どの日用品が切れそうか***をアプリから管理できたら便利だなと考え、制作を決めました。

## ターゲットとなるユーザー層
- 一人暮らししてる人
- 忘れっぽい人
- 管理する消耗品が多いと感じている人

## サービスの利用イメージ
- ユーザーは通知してほしい日用品を登録します。
- アプリ内で残量が少なくなる日時を予測し、その日時になったところでユーザーへLINE通知を送ります。
- ユーザーはLINE通知を見ることで、どの日用品を購入すればいいか確認することができます。

## ユーザーの獲得・宣伝方法
- Xによる宣伝
- ソーシャルポートフォリオへの掲載
- RUNTEQコミュニティのtimesなどに掲載

## サービスの差別化ポイント
モバイルアプリに似たような在庫管理アプリがいくつかありました。自身でインストールし、実際に触れてみて感じた差別化ポイントを上げていきます。
- 通知機能:プッシュ通知を送ることで、ユーザーが購入タイミングを逃すことを防ぎます。
- 残量の予測:通知タイミングを自動で算出します。商品の内包量と詰め替え用などの在庫数から、在庫が減ってきたタイミングを測って通知を出してくれます。

## MVP
- ユーザー登録・ログイン
  - ユーザー名,パスワード
  - LINE連携ログイン  **入力必須**
  - LINEに友達追加
- 日用品の登録機能
  - ジャンル選択(シャンプー、ティッシュBOXなど):選択したジャンルごとにフォーマット用意し、そのページに遷移
  - 商品名入力
    - 空欄でもOK（フリーメモと統合するかもしれません）
  - 内包量
    - フォーマットごとに単位が変わる。 **入力必須**
  - １日の使用回数  **入力必須**
  - フリーメモ
    - ユーザーは自由に書き込めます。内容はLINE通知の際に一緒に表示されます。
- 登録した日用品一覧の表示、詳細、編集、削除
  - ユーザーはトップページに上記登録内容が表示されます。
  - 通知予定日時が一覧、詳細画面に確認できます。
    - 通知予定日時をユーザーが任意で変更できます。
- LINEへの通知
  - 通知を受け取れます。

## 本リリース実装予定
- LINEリッチメニュー機能
  - LINE上のメニューから、現在登録されている内容の確認や変更、更新が行えます。

## 通知タイミングの計算方法
通知タイミングは、以下の計算式から条件を満たすまでループ処理で算出します。  
算出された日時に通知を送ります。  

#### 計算式 ####

___[ 通知タイミング(何日後か) = ( 内包量 - 1日の推定消費量 ) <= 内包量 * 1/3 ]___

**1日の推定消費量** = ( (1回の平均使用量 or メーカー等が推奨する１回の適量) * 1日の推定使用回数 * 使用日数 )  
**内包量**:ユーザーが入力します。
**1日の推定使用回数**:ユーザーが入力します。

#### 解説 ####

**1日の平均使用量**:インターネットで検索した、メーカーやまとめサイトなどから一人暮らしの平均消費量を１日あたりに換算して採用します。  
**メーカー等が推奨する１回の適量**:ユーザーごとの消費量に大きく差がある日用品（化粧品）などはこちらを元に計算します。  
**１日の推定使用回数**:ユーザーに一日に大体どれくらい使うかを入力してもらいます。これにより、より正確に１日の使用量を計算できます。
**使用日数**:計算時にループ処理で+1ずつ、条件を満たすまで日数を追加してきます。  

## 本アプリで登録可能な日用品（暫定）
今回は消費量データを見つけることのできた以下のものをジャンル洗濯できるようにします。  
当てはまらないジャンルはすべてその他に登録してもらい、通知タイミングも個人で設定してもらいます。  
他の日用品に関するデータ等があれば追加します。

- 日用品:シャンプー ボディソープ 洗濯洗剤 柔軟剤 食器用洗剤 ティッシュBOX
- 化粧品:化粧水 美容液 保湿クリーム クレンジング 洗顔料 日焼け止め
- その他

## 懸念点と対策
- これらの消費量、特に化粧品は個人差が大きく正確に計算できない可能性が高いため、「使い方」などにそれらの注意事項を明記します。
- 計算結果の1回目の精度に不安があります。ユーザーが想定より多く消費している場合、通知前に在庫を切らしてしまうことが考えられます。

**対策**
  - 設定から10日が経過するごとに「現在の消耗はどうでしょうか？」などと気に掛ける通知を送ることで、1回目の精度不安からのユーザーが気づかないうちに在庫切れという事態を防ぎます。
  - 登録した日用品の編集ページ内から、自身で通知日時を設定変更できるようにします。通知結果が遅いと感じたユーザーは、いつでも自分で調整することが可能です。（本リリース後、カレンダーからも変更が可能）

※これ以上に極端に外れるパターンだと、ユーザー自身で通知タイミングを編集画面から設定してもらうことになると思います。

## 使用技術
- JavaScript/Hotwire/TailwindCSS/DaisyUI
- Ruby on Rails7.1.4.2
- Docker/docker-compose
- GitHub Actions
- devise
- MySQL
- Heroku/Cloudflare
- API:LINEログイン/LINEMessaging API

### 画面遷移図
Figma: https://www.figma.com/design/2VwD5fdGWkb8wJjEbBMAnv/%E5%8D%92%E6%A5%AD%E5%88%B6%E4%BD%9C%E3%82%A2%E3%83%97%E3%83%AA%E3%80%80%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E8%A8%AD%E5%AE%9A?node-id=0-1&node-type=canvas&t=e5a8zFrOt7y4jZOS-0

## READMEに記載した機能
###  MVP
- [x] ユーザー登録機能
- [x] ログイン機能
- [x] パスワード変更機能
- [x] LINE友達追加QRコード
- [x] マイページ
  - [x] 日用品 新規登録機能
  - [x] 日用品 編集機能
  - [x] 日用品 削除機能
  - [x] 日用品 通知日表示機能
- [x] LINE通知機能

### 本リリース
- [x] LINEリッチメニュー
  - [x] 登録している日用品の確認・変更
  - [x] 通知日の確認・変更機能
  - [x] フリーメモ確認・変更

### メールアドレス・パスワード変更確認項目
直接変更できるものではなく、一旦メールなどを介して専用のページで変更する画面遷移になっているか？
- [x] メールアドレス
- [x] パスワード

### 各画面の作り込み
画面遷移だけでなく、必要なボタンやフォームが確認できるくらい作り込めているか？
- [x] 作り込みはある程度完了している（Figmaを見て画面の作成ができる状態にある）

## ER図
[![Image from Gyazo](https://i.gyazo.com/1c93de0eb2549a3c930d66a3f4ae99ea.png)](https://gyazo.com/1c93de0eb2549a3c930d66a3f4ae99ea)

### 各テーブルの解説
- Usersテーブル:LINEログイン機能とLINE通知機能を実装する観点から、プロバイダー情報とユーザーIDを保存するためにprovider,uidカラムを設定しました。

- Itemsテーブル:ユーザーが登録した情報を表示します。
  - name:商品名
  - volume:内包量
  - used_count_per_day:一日の使用回数
  - memo:フリーメモ

- Notificationsテーブル:算出された通知日を保存します。在庫補充された際、通知日の再設定をする際に使用する前回通知日やインターバル情報を保存するため、通知関連はItemsテーブルから独立させたテーブルに保存します。
  - next_notification_day:通知予定日
  - last_notification_day:前回通知日
  - notification_interval:通知予定日までの間隔
