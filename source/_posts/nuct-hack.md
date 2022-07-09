---
title: NUCTハック
date: 2022-07-09 17:15:19
tags: ["coding", "NUCT"]
categories: ["NUCT"]
---

# はじめに
この記事では私が知り得た，名大の学習支援システムである[NUCT](https://ct.nagoya-u.ac.jp/portal)をハックするための情報をまとめます．APIは名大生しか叩くことができませんが，それ以外情報はGoogle先生を駆使すれば誰でも辿り着ける情報です．

# 1. そもそもNUCTとは．

実は，NUCTは名大の人が0から作ったサービスではありません．実はオープンソースのSakaiというプロジェクトを元にして作られています．

その証拠に，NUCTを開いて，一番下までスクロールしてみてください．
![nuctにpowerd-by-sakaiと書いてある](/images/nuct-powerd-by-sakai.png)
このように[Powerd by Sakai](https://www.sakailms.org/)と書いてあります．SakaiはオープンソースのLMS(学習管理システム: Learning Management System)です．オープンソースなので，だれでも[こちら](http://source.sakaiproject.org/release/22.0/)からダウンロードして自由に使うことができますし，ソースコードは[こちら](https://github.com/sakaiproject/sakai)に公開されています．

ということは，NUCTではSakaiが提供するツールが使えるということではないでしょうか？

<details>
<summary>コラム：NUCTをさらに詳しく知る</summary>

NUCTは2010年度から[(出典)](https://www.hosei.ac.jp/application/files/5315/7656/1949/JaSakaiConf5_ohta.pdf)提供されており，Sakaiを元にして名大独自のアレンジを加えたシステムとなっています．独自のアレンジの例としては，NUCTの情報と連携した動画配信サービスがあるそうです[(出典)](
https://www.hosei.ac.jp/application/files/9815/7655/7741/JaSakai2015_nagoya-u.pdf)．また，2020年のCOVID-19の一斉休校の際はNUCTによるDXにさまざまな工夫がされていたようです[(資料pdf)](https://www.nii.ac.jp/event/upload/20210326-06_Mori.pdf), [(当時作られたであろう教員向けサイト)](https://media.itc.nagoya-u.ac.jp/nuct_how_to_use_2020/)．
</details>


# 2. SakaiのAPI
SakaiにはAPIのエンドポイントがあります．ブラウザから簡単に確認することができます．NUCTにログインした状態で https://ct.nagoya-u.ac.jp/direct/describe にアクセスしてみましょう．するとAPIの使い方一覧が出てきます．

有用そうなエンドポイントを貼っておきます．(末尾の.jsonを.xmlに変えるとxmlで取得できます)
1. NUCTの講義サイトのID等がわかるjson
https://ct.nagoya-u.ac.jp/direct/site.json
※説明にもあるようにクエリパラメータを付けることができます．0がallを意味します．
https://ct.nagoya-u.ac.jp/direct/site.json?_limit=0

2. 課題の一覧のjson
https://ct.nagoya-u.ac.jp/direct/assignment/my.json

3. カレンダーの情報のjson
https://ct.nagoya-u.ac.jp/direct/calendar/my.json

4. ある授業のリソースの一覧のjson
https://ct.nagoya-u.ac.jp/direct/content/site/{site_id}.json

これらのエンドポイントからデータを取得するためにはNUCTにログイン済みである必要がある（＝アクセスするときにCookieを送らないといけない）ため，cookieを手に入れる工夫は必要ですが，これだけ情報があれば色々なことに使えそうですね．

さらに詳しいAPIの情報はこちらの[sakaiのwiki](https://sakaiproject.atlassian.net/wiki/spaces/CONF/overview?mode=global)も見てみるといいかもしれません．
# 3. Confortable Sakai

前述のSakaiのAPIを用いた神Chrome拡張として，[Comfortable Sakai](https://github.com/kyoto-u/comfortable-sakai)があります．
Chromeに導入する場合は[こちら](https://chrome.google.com/webstore/detail/comfortable-sakai/dljchadmceknaijmdmnaaodjkkidhakh?hl=ja&authuser=0)から．
Comfortable Sakaiとは：
>NUCTのベースとなっているSakaiというシステムに適用可能なブラウザ拡張機能が，京都大学の武田和樹さん（工学部電気電子工学科4回生【2022年度時点】）を中心とした有志により作成・公開されています．

↑NUCTの公式の[このページ](https://media.itc.nagoya-u.ac.jp/nuct_faq/faq_ComfortableSakai.html)より引用．

実は，京都大学でもSakaiを元にしたPandAというLMSが使われており，Comfortable Sakaiは元々PandA用の拡張機能として開発されたそうです[(Comfortable PandA公式ページ)](https://cpanda.das82.com/),[(開発者へのインタビュー)](https://www.highedu.kyoto-u.ac.jp/connect/topics/comfortable_panda01.php),[(Comfortable PandAをリリースした話)](https://note.com/das08/n/n09e1606f5277)．

PandAのAPIを使っている方は他にもいらっしゃいました．多すぎん…？笑
(GitHubの検索窓で「panda kyoto-u」とかでコードを調べるとごろごろ出てくる)
<details><summary>詳細</summary>

- [京大の学習支援システムをハックする](https://kmconner.net/posts/2019/12/23-panda-console/)
    - [PandA上のリソースを一括ダウンロード](https://github.com/KMConner/PandaConsole)
    - [記事を参考にして作られたGo製の授業資料ダウンロードアプリ](https://github.com/santamn/PandorA)
- [clipanda](https://github.com/face0u0/clipanda)PandAのcliツール
- [PandAroid](https://github.com/tinaxd/PandAroid/tree/0cb4fd4048af85e46661233ea9072a66d94165d7)Android上からPandAの課題を確認するアプリ
- [Slack BotにPandA上の課題を通知してもらってるっぽい](https://github.com/huji333/natori-bot/blob/b20d4ca95de1e8eada2947295299239333f85840/SlackbotModules/Assignments.py)
- [Comfortable PandAのiOS移植](https://github.com/das08/ComfortablePandA-iOS)
- [PandA-Mix-Plus](https://github.com/OkanoShinri/PandA-Mix-Plus)授業のタブを時間割のように表示するアドオン
- [京都大学課題確認アプリ](https://github.com/kenbun/ku_panda_app)

コード見る限り，京大は多要素認証がなく，idとパスワードだけのcas認証でログインしているように見えました．わからないけど．

同様に，名大でもAPIを使っている人がいないか探してみましたが，あまりいませんでした…
多要素認証になる前のNUCTで使えるコードを書いている方はいらっしゃいました：https://github.com/nu50218/go-nagoyau

</details>

# 4. その他ハック

1. 多要素認証自動化
https://github.com/obashun22/auto-mfa-cas-login
こちらのChrome拡張を用いれば多要素認証を自動化することができます．
もちろん，ちゃんとしたやり方で認証するよりは多少はセキュリティが落ちると思いますので，使う際は自己責任で……（ただめちゃめちゃ便利）

2. 課題をGoogle Tasksに追加する
NUCTにはカレンダーのエクスポート機能があります．それをGoogleカレンダーに取り込んで，Google Tasksに変換するという仕組みです．詳しくは[こちら](/2021/08/10/nuct-schedule-to-gtasks-with-gas/)

3. SakaiのiOSクライアント
以下のようなSakaiのiOSクライアントを開発されている方がいらっしゃいます．
iOSのアプリ開発がわかる方，動かしてみてくれないかなあ……
https://github.com/alihen/Sakai-iOS
https://github.com/PRAN1999/SakaiClientiOS

# 終わりに
いかがでしたでしょうか．この記事を見て誰かがいい感じのNUCT拡張を作ってくれないかな…と期待しています…！
