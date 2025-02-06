# サービス名: StockMate
[![Image from Gyazo](https://i.gyazo.com/7c4ae9f5eeafaf40df2bc46f2b7bc021.jpg)](https://gyazo.com/7c4ae9f5eeafaf40df2bc46f2b7bc021)
## サービス概要
登録された日用品の消耗具合を予測して、減ってきたタイミングで通知してくれます。
通知をLINE履歴で確認できるので、「何買えばいいんだっけ？」とわからなくなることを防止することができます。
## 開発背景
一人暮らしをしていると、以下のようなシチュエーションがありました。

普段使っているシャンプーの残量が少なくなってきていることに気付き、明日の仕事帰りにドラッグストアに寄ることにした。
しかし次の日、帰宅後に買って帰ることを忘れていたことを、シャワーを浴びてから気付いた。
休日になり、ドラッグストアで在庫を購入し帰宅したところ、今度は食器用洗剤の量が少なくなっていることに気づいた。

このように***日用品の買い忘れ***や***次はいつ、どの日用品が切れそうか***をアプリから管理できたら便利だなと考え、制作を決めました。

## ターゲットとなるユーザー層
- 一人暮らししてる人
- 忘れっぽい人
- 管理する消耗品が多いと感じている人

## サービスの利用イメージ
### 新規作成・編集
[![Image from Gyazo](https://i.gyazo.com/d6d1bcce33b92a95273aaba79f154978.png)](https://gyazo.com/d6d1bcce33b92a95273aaba79f154978)

### 詳細ページ
[![Image from Gyazo](https://i.gyazo.com/23fd9412c04772f32265aafda93fc518.png)](https://gyazo.com/23fd9412c04772f32265aafda93fc518)
- 一覧ページのカテゴリーアイコンをタップすると確認できます

### 通知予定日の編集
[![Image from Gyazo](https://i.gyazo.com/63eccb049f39540b59ffd2fb9ef74fef.png)](https://gyazo.com/63eccb049f39540b59ffd2fb9ef74fef)

### LINE画面での操作
[![Image from Gyazo](https://i.gyazo.com/c9a4e87a9cb61580c04477fd6183cd9a.png)](https://gyazo.com/c9a4e87a9cb61580c04477fd6183cd9a)


## ユーザーの獲得・宣伝方法
- Xによる宣伝
- ソーシャルポートフォリオへの掲載
- RUNTEQコミュニティのtimesなどに掲載

## サービスの差別化ポイント
モバイルアプリに似たような在庫管理アプリがいくつかありました。自分でインストールし、実際に触れてみて感じた差別化ポイントを上げていきます。

- 通知機能: プッシュ通知を送ることで、ユーザーが購入タイミングを逃すことを防ぎます
- 残量の予測: 通知タイミングを自動で算出します。商品の内包量と詰め替え用などの在庫数から、在庫が減ってきたタイミングを測って通知を出してくれます

## 実装機能
- ユーザー登録・ログイン
  - ユーザー名, パスワード
  - LINE連携ログイン  **入力必須**
- 日用品の登録機能
  - ジャンル選択(シャンプー、食器用洗剤など): 選択したジャンルに対応した単位を内包量の欄に表示します　**入力必須**
  - 商品名入力　**入力必須**
  - 内包量: カテゴリーに対応した単位が表示されます **入力必須**
  - １週間の使用回数  **入力必須**
  - フリーメモ: ユーザーは自由に書き込めます。内容はLINE通知の際に一緒に表示されます
- 登録した日用品一覧の表示、詳細、編集、削除
  - 一覧ページに入力内容のうち、商品名・カテゴリー・通知予定日が表示されます
  - 登録されたカテゴリーに対応するアイコンが表示されます
  - 入力した全ての内容を詳細画面で確認できます
    - 通知予定日時をユーザーが任意で変更できます
- LINEへの通知
  - 通知を受け取れます

- LINEリッチメニュー機能
  - LINE上のメニューから、以下の操作が行えます
    - 「登録確認」: 登録内容を一覧でユーザーに送信します
    - 「在庫補充」: 通知があった日用品の補充設定。タップすると商品名を聞かれるので、登録した商品名を入力するとその日用品の通知日を再計算し設定します
    - アプリのリンク: タップすることで簡単にアクセスできます

## 通知タイミングの計算方法
通知タイミングは、以下の計算式から条件を満たすまでループ処理で算出します。  
算出された日時に通知を送ります。  

#### 計算式 ####

___[通知タイミング(何日後か) = (内包量 - 1日の推定消費量) <= 内包量 * 1/3]___

**1日の推定消費量** = ( (1回の平均使用量 or メーカー等が推奨する１回の適量) * 1日の推定使用回数 * 使用日数 )  
**内包量**: ユーザーが入力します。
**1日の推定使用回数**: ユーザーが入力した「一週間の使用回数」 / 7.0 の小数点第二位までの値を使用します。

#### 解説 ####

**1日の平均使用量**: インターネットで検索した、メーカーやまとめサイトなどから一人暮らしの平均消費量を１日あたりに換算して採用します。  
**メーカー等が推奨する１回の適量**: ユーザーごとの消費量に大きく差がある日用品（化粧品）などはこちらを元に計算します。  
**１日の推定使用回数**: ユーザーは一週間に何回ぐらい使用するかを入力します。そうすることで毎日使用しない日用品に対する計算の精度を向上させました。
**使用日数**: 計算時にループ処理で+1ずつ、条件を満たすまで日数を追加してきます。

- また、ユーザーが任意の日用品等を登録できるようにその他というカテゴリーを設けていますが、こちらは計算を行わずに自動的に二週間後に通知となっています。

## 本アプリで登録可能な日用品
今回は消費量データを見つけることのできた以下のものをジャンルで選択できるようにします。  
当てはまらないジャンルはすべてその他に登録してもらい、通知タイミングも個人で設定してもらいます。  
他の日用品に関するデータ等があれば追加します。

日用品: シャンプー, ボディソープ, 食器用洗剤, 洗濯用洗剤(粉)・(液), 柔軟剤
化粧品: 化粧水, 美容液, 保湿クリーム, 洗顔料, 日焼け止め
その他

## 懸念点と対策
これらの消費量、とりわけ化粧品は個人差が大きく正確に計算できない可能性が高いため、「使い方」などにそれらの注意事項を明記します。
計算結果の1回目の精度に不安があります。ユーザーが想定より多く消費している場合、通知前に在庫を切らしてしまうことが考えられます。

**対策**
登録した日用品の編集ページ内から、自分で通知日時を設定変更できるようにします。通知結果が遅いと感じたユーザーは、いつでも自分で調整することが可能です。

## 使用技術
- JavaScript/Stimulus/TailwindCSS/DaisyUI
- Ruby on Rails7.1.4.2
- Docker
- GitHub Actions
- devise
- MySQL
- Heroku/Cloudflare
- LINE Messaging API

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
- Usersテーブル: LINEログイン機能とLINE通知機能を実装する観点から、プロバイダー情報とユーザーIDを保存するためにprovider,uidカラムを設定しました。

- Itemsテーブル: ユーザーが登録した情報を表示します。
  - category: カテゴリー
  - name: 商品名
  - volume: 内包量
  - used_count_per_weekly: 一週間の使用回数
  - memo: フリーメモ

- Notificationsテーブル: 算出された通知日を保存します。在庫補充された際、通知日の再設定をする際に使用する前回通知日やインターバル情報を保存するため、通知関連はItemsテーブルから独立させたテーブルに保存します
  - next_notification_day: 通知予定日
  - last_notification_day: 前回通知日
  - notification_interval: 通知予定日までの間隔
