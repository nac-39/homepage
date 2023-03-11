---
title: Macおすすめのソフト＆セットアップ2023春(上級編)
date: 2023-03-10 17:33:51
tags:
  - mac
categories:
  - tips
mathjax: true
---

## 対象読者

- この春 Mac を新しく買った名大生
- Mac を持っているけど、いまいち使いこなせておらず、もっと便利なアプリを探している名大生

に向けて、買ったばかりのまっさらの Mac をセットアップしていく想定で記事を書いていきます。

上級編では、普段私が使っている便利なもので、若干マニアックなものも含めて紹介していきます。

<!-- more -->

## ブラウザ

基本編で Chrome を紹介したのですが、実は私がメインで使ってるブラウザは Chrome ではなく Vivaldi です。

- [Vivaldi](https://vivaldi.com)

実は Chrome より機能が少ない Chromium という Google が開発しているブラウザはソースコードが公開されていて、誰でも自由に改変することができます。Vivaldi はその Chromium を改造して作られたブラウザです。

Vivaldi で気に入っているのは、次のような点です。

- **マウスジェスチャが使える**（これのために使ってる）
- タブ、アドレスバーなどが Chrome より薄い
- パネル機能がある（Twitter を入れると一瞬確認するのに便利）

他にもコマンドパレットが出せたりするのも便利です。

## メモ帳

授業のノートをマークダウンという記法で取っています。
マークダウンというのは、

```markdown
### タイトル

- 箇条書き a
- 箇条書き b

1. 数式もかける

$x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$
```

と書いたら

---

### タイトル

- 箇条書き a
- 箇条書き b

1. 数式もかける

## $x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$

---

と表示される記法です。Word でノートをとるよりもこっちでノートを取った方が圧倒的に楽なので使っています。

マークダウンでメモを取るためのエディタとして、Obsidian を使っています。

- [Obsidian](https://obsidian.md)

マークダウンはそれこそ Notion などで書いてもいいのですが、他のサービスでは自分でデータを持っておくことができません。例えば、Notion だと、Notion のサーバー上にマークダウンが保存されてしまうので、授業資料との関連が失われてしまいますし、またサ終によってデータが失われてしまう可能性もあります。

Obsidian を使っている最大のメリットは授業の他の資料と関連した場所にマークダウンファイルの本体を置けることです。Obsidian 上で PDF を閲覧することもできるので、ノートと PDF を同じウィンドウで見たい時にも重宝します。

例えば、ある授業の OneDrive の中のファイル構造はこうなっています。

```plaintext
.
├── logic-lecture-notes-2022-v2.pdf
├── logic-lecture-notes-2022-v3.pdf
├── logic-lecture-notes-2022.pdf
├── 課題
│   ├── 2022論理学2a 課題1.pdf
│   ├── 2022論理学2a 課題2.pdf
│   ├── 2022論理学2a 課題3.pdf
│   └── 論理学2.pdf
└── ノート
    └── 第一回.md

3 directories, 9 files
```

このように、授業の pdf とマークダウンファイルをいっぺんに管理できます。

Obsidian の唯一の欠点は OneDrive にあるファイルをスマホや iPad から見ることができないというところですね。PC 常備していないと講義のメモを取るのには使えないです。。

## RayCast

Spotlight 検索や Alfred のようなランチャーアプリです。

- [Raycast](https://www.raycast.com)

Raycast は自分で拡張機能を開発できることもあり、無限に機能があるのですが、その中でも自分が気に入ってよく使っている機能は、

- クリップボードマネージャー：コピペの履歴を保存しておいてくれる。履歴を検索できるので Clipy よりも便利だと思う。
- 計算機、単位換算：プロンプトに$100 とか入れると日本円に換算してくれたりする。簡易的な電卓としても使える。sqrt()でルートを認識してくれたりして便利。
- 標準カレンダー、リマインダーとの統合
- Raycast の全ての機能にショートカットキーを割り振れる
- ファイル検索。Spotlight よりも断然速い気がする。

この辺が特に便利です。あとはウィンドウマネージャーもついてるので、こだわりがなければこれだけで十分ですね。

## Rectangle

ウィンドウマネージャーです。同系統のアプリだと、[Magnet](https://magnet.crowdcafe.com)とか[ShiftIt](https://github.com/fikovnik/ShiftIt/releases)とか、[Lasso](https://thelasso.app)とかがありますね。あと、Raycast にもウィンドウマネージャー機能がついています。

- [Rectangle](https://rectangleapp.com)

Rectangle のいいところは、Ubuntu や Windows みたいに、ウィンドウをドラッグして画面の端に持っていくと２分割してくれる機能がついているところです。

この画面分割には微妙にこだわりがあって、ShiftIt も Raycast のウィンドウマネージャも使ったことあるし、他にもキーボードだけでウィンドウの操作を完結でき、ウィンドウを常にタイル状に保ってくれる yabai と skhd というソフトを使っていたこともあります。（[yabai の参考記事](https://zenn.dev/yootaki/articles/d6ba758c63a315)）

ただ、これだけ使ってきた中でもやっぱりマウスのドラッグで画面に分割ができるのは Rectangle だけなので、今はこれ推しです。

## RunCat

Mac の CPU 使用率に応じてコマ送りの速度が変化するアニメーションをメニューバーに表示してくれるアプリです

- [RunCat](https://kyome.io/runcat/)

全力で走る猫もまったり歩く猫もかわいい。全人類入れろ。以上！

## ターミナル系

ターミナルの設定系は dotfiles を見てもらうのが速いと思います。

- [nac-39 / dotfiles](https://github.com/nac-39/dotfiles)

過去に最高に怠惰なターミナルを作ろうというスライドを作ったのでこちらを見てください。

[github](https://github.com/nac-39/slides/tree/main/jack-lt-2022-fall)

<embed src="https://nac-39.github.io/slides/jack-lt-2022-fall/slide.pdf" width="100%" height="500" title="最高に怠惰なターミナルのスライド" />
