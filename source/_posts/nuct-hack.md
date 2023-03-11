---
title: NUCTハック
date: 2022-07-09 17:15:19
tags: ["coding", "NUCT"]
categories: ["NUCT"]
---

# はじめに

この記事では私が知り得た，名大の学習支援システムである[NUCT](https://ct.nagoya-u.ac.jp/portal)をハックするための情報をまとめます．API は名大生しか叩くことができませんが，それ以外情報は Google 先生を駆使すれば誰でも辿り着ける情報です．

<!-- more -->

# 1. そもそも NUCT とは．

実は，NUCT は名大の人が 0 から作ったサービスではありません．実はオープンソースの Sakai というプロジェクトを元にして作られています．

その証拠に，NUCT を開いて，一番下までスクロールしてみてください．
![nuctにpowerd-by-sakaiと書いてある](/images/nuct-powerd-by-sakai.png)
このように[Powerd by Sakai](https://www.sakailms.org/)と書いてあります．Sakai はオープンソースの LMS(学習管理システム: Learning Management System)です．オープンソースなので，だれでも[こちら](http://source.sakaiproject.org/release/22.0/)からダウンロードして自由に使うことができますし，ソースコードは[こちら](https://github.com/sakaiproject/sakai)に公開されています．

つまり，NUCT では Sakai のために開発されたツールを使うことができるのです！

<details>
<summary>コラム：NUCTをさらに詳しく知る</summary>

NUCT は 2010 年度から[(出典)](https://www.hosei.ac.jp/application/files/5315/7656/1949/JaSakaiConf5_ohta.pdf)提供されており，Sakai を元にして名大独自のアレンジを加えたシステムとなっています．独自のアレンジの例としては，NUCT の情報と連携した動画配信サービスがあるそうです[(出典)](https://www.hosei.ac.jp/application/files/9815/7655/7741/JaSakai2015_nagoya-u.pdf)．また，2020 年の COVID-19 の一斉休校の際は NUCT による DX にさまざまな工夫がされていたようです[(資料 pdf)](https://www.nii.ac.jp/event/upload/20210326-06_Mori.pdf), [(当時作られたであろう教員向けサイト)](https://media.itc.nagoya-u.ac.jp/nuct_how_to_use_2020/)．

</details>

# 2. Sakai の API

Sakai には API のエンドポイントがあります．ブラウザから簡単に確認することができます．NUCT にログインした状態で https://ct.nagoya-u.ac.jp/direct/describe にアクセスしてみましょう．すると API の使い方一覧が出てきます．

有用そうなエンドポイントを貼っておきます．(末尾の.json を.xml に変えると xml で取得できます)

1. NUCT の講義サイトの ID 等がわかる json
   https://ct.nagoya-u.ac.jp/direct/site.json
   ※説明にもあるようにクエリパラメータを付けることができます．0 が all を意味します．
   https://ct.nagoya-u.ac.jp/direct/site.json?_limit=0

2. 課題の一覧の json
   https://ct.nagoya-u.ac.jp/direct/assignment/my.json

3. カレンダーの情報の json
   https://ct.nagoya-u.ac.jp/direct/calendar/my.json

4. ある授業のリソースの一覧の json
   https://ct.nagoya-u.ac.jp/direct/content/site/{site_id}.json

これらのエンドポイントからデータを取得するためには NUCT にログイン済みである必要がある（＝アクセスするときに Cookie を送らないといけない）ため，cookie を手に入れる工夫は必要ですが，これだけ情報があれば色々なことに使えそうですね．

さらに詳しい API の情報はこちらの[sakai の wiki](https://sakaiproject.atlassian.net/wiki/spaces/CONF/overview?mode=global)も見てみるといいかもしれません．

# 3. Confortable Sakai

前述の Sakai の API を用いた神 Chrome 拡張として，[Comfortable Sakai](https://github.com/kyoto-u/comfortable-sakai)があります．
Chrome に導入する場合は[こちら](https://chrome.google.com/webstore/detail/comfortable-sakai/dljchadmceknaijmdmnaaodjkkidhakh?hl=ja&authuser=0)から．
Comfortable Sakai とは：

> NUCT のベースとなっている Sakai というシステムに適用可能なブラウザ拡張機能が，京都大学の武田和樹さん（工学部電気電子工学科 4 回生【2022 年度時点】）を中心とした有志により作成・公開されています．

↑NUCT の公式の[このページ](https://media.itc.nagoya-u.ac.jp/nuct_faq/faq_ComfortableSakai.html)より引用．

実は，京都大学でも Sakai を元にした PandA という LMS が使われており，Comfortable Sakai は元々 PandA 用の拡張機能として開発されたそうです[(Comfortable PandA 公式ページ)](https://cpanda.das82.com/),[(開発者へのインタビュー)](https://www.highedu.kyoto-u.ac.jp/connect/topics/comfortable_panda01.php),[(Comfortable PandA をリリースした話)](https://note.com/das08/n/n09e1606f5277)．

PandA の API を使っている方は他にもいらっしゃいました．多すぎん…？笑
(GitHub の検索窓で「panda kyoto-u」とかでコードを調べるとごろごろ出てくる)

<details><summary>詳細</summary>

- [京大の学習支援システムをハックする](https://kmconner.net/posts/2019/12/23-panda-console/)
  - [PandA 上のリソースを一括ダウンロード](https://github.com/KMConner/PandaConsole)
  - [記事を参考にして作られた Go 製の授業資料ダウンロードアプリ](https://github.com/santamn/PandorA)
- [clipanda](https://github.com/face0u0/clipanda)PandA の cli ツール
- [PandAroid](https://github.com/tinaxd/PandAroid/tree/0cb4fd4048af85e46661233ea9072a66d94165d7)Android 上から PandA の課題を確認するアプリ
- [Slack Bot に PandA 上の課題を通知してもらってるっぽい](https://github.com/huji333/natori-bot/blob/b20d4ca95de1e8eada2947295299239333f85840/SlackbotModules/Assignments.py)
- [Comfortable PandA の iOS 移植](https://github.com/das08/ComfortablePandA-iOS)
- [PandA-Mix-Plus](https://github.com/OkanoShinri/PandA-Mix-Plus)授業のタブを時間割のように表示するアドオン
- [京都大学課題確認アプリ](https://github.com/kenbun/ku_panda_app)

コード見る限り，京大は多要素認証がなく，id とパスワードだけの cas 認証でログインしているように見えました．わからないけど．

同様に，名大でも API を使っている人がいないか探してみましたが，あまりいませんでした…
多要素認証になる前の NUCT で使えるコードを書いている方はいらっしゃいました：https://github.com/nu50218/go-nagoyau

</details>

# 4. その他ハック

1. 多要素認証自動化
   https://github.com/obashun22/auto-mfa-cas-login
   こちらの Chrome 拡張を用いれば多要素認証を自動化することができます．
   もちろん，ちゃんとしたやり方で認証するよりは多少はセキュリティが落ちると思いますので，使う際は自己責任で……（ただめちゃめちゃ便利）

2. 課題を Google Tasks に追加する
   NUCT にはカレンダーのエクスポート機能があります．それを Google カレンダーに取り込んで，Google Tasks に変換するという仕組みです．詳しくは[こちら](/2021/08/10/nuct-schedule-to-gtasks-with-gas/)

3. Sakai の iOS クライアント
   以下のような Sakai の iOS クライアントを開発されている方がいらっしゃいます．
   iOS のアプリ開発がわかる方，動かしてみてくれないかなあ……
   https://github.com/alihen/Sakai-iOS
   https://github.com/PRAN1999/SakaiClientiOS

# 終わりに

いかがでしたでしょうか．この記事を見て誰かがいい感じの NUCT 拡張を作ってくれないかな…と期待しています…！
