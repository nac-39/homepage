---
title: gatherのbotの解説 
date: 2023-05-27 14:09:26
tags: ["gather", "slack", "tool", "coding", "JavaScript"]
categories: "tips"
---

過去にgather_botの作り方について解説した文章が出てきたので、公開しておきます。これを書いたのは2021年で、現在も情報が正しいかは検証していません。すみません。気が向いたら更新します…

こちらのコードを書いた時の解説になります。
[https://github.com/nac-39/slack-bot_gather_member](https://github.com/nac-39/slack-bot_gather_member)

<!-- more -->

## botを作った背景
所属しているサークルでgatherを導入しており、外からだと何人そのスペースにいるかはわかるけど、誰がいるのかはわからないためgatherに入りづらいという問題が起こっていました（人数多いし盛り上がってるのかな？と思って入ったら先輩しかいなくて気まずい等）。そこで色々考えたのですが、最終的にslackのbotを作るということに落ち着きました。

## slack-bot_gather_memberのコードの解説

制作に使用したのが、npmで配布されているgatherのライブラリで、gather-game-clientです。
URL: https://www.npmjs.com/package/@gathertown/gather-game-client

npmなのでnodejsで使うことができます。nodejsはサーバーサイドで動くjavascriptです。
gatherのapi-keyをgatherにロクインした状態で [https://gather.town/apiKeys](https://gather.town/apiKeys) ここから取得し、環境変数に入れるか、.envファイルに記述してnodejsのdotenvライブラリを使って読み込みます。あとは諸々を初期化します。

```javascript
import { Game } from "@gathertown/gather-game-client";
import dotenv from "dotenv";
import webSocket from "isomorphic-ws";

dotenv.config();//.envファイルを読み込めるようにする
global.WebSocket = webSocket;//websocketの何かの初期化
```
```javascript
const onConnected = (connected) => {
	console.log("Connected: ", connected);
	game.enter(process.env.SPACE_ID);
	console.log(Object.keys(game.players));
	console.log(game.getStats());
};
// gatherのgameクラス初期化
const game = new Game(process.env.SPACE_ID, () =>
	Promise.resolve({ apiKey: process.env.API_KEY })
);
game.connect();
game.subscribeToConnection(onConnected);
```

これで自分のアカウントがログインしているスペースの情報をゲットする準備が出来ました。
あとは、gameクラスに含まれている諸々の関数を使って色々な情報をゲットすることができます。
例えば、プレイヤーがスペースに入ったことを検知するには`game.subscribeToEvent`という関数が使えます。
```javascript
game.subscribeToEvent("playerJoins", (player) => {
	console.log("playerJoined");
	setTimeout(async () => {
		Object.keys(game.players).forEach((e) => {
		console.log(game.getPlayer(e));
	}, 5000); // プレイヤーが入室してからgame.playersに反映されるのに少し時間がかる
});
```
このsubscribeToEventの第一引数に何が入るかは[ここ](http://gather-game-client-docs.s3-website-us-west-2.amazonaws.com/classes/Game.html#subscribeToEvent)に書いてあります。

私がやったことあるのはここまでなので、マップの操作とかはわからないです。

## もろもろ
- GatherのAPIは後方互換性とかはあまり考えずに開発していくそうなので、もしかしたらコードが古くなると使えなくなるかもしれません。（websocket apiのドキュメントに書いてありましたし、実際v35->v36に上がった時に動かなくなりました。npmのバージョンを上げたら動きましたがいつ動かなくなるかわかりません。）
- githubにDockerfileも上げてあるので、その環境でなら動作するはずです。
- slackに投稿する方はslack boltというライブラリを使いました。http叩くコードを書かなくて良いのでとても楽です。


## gatherのAPI系お役立ちリンク集
- 自分と同じように困っている人が大概いるforum：
	- [https://forum.gather.town/](https://forum.gather.town/)
	- ほとんどここのコードを参考にしました。
- gatherのhttpのapi
	- ドキュメント：[https://www.notion.so/Gather-HTTP-API-3bbf6c59325f40aca7ef5ce14c677444](https://www.notion.so/Gather-HTTP-API-3bbf6c59325f40aca7ef5ce14c677444)  
	- Nodejsラッパー：[https://github.com/warengonzaga/gathertown.js](https://github.com/warengonzaga/gathertown.js)
- gatherのwebsocketのapi：
	- [https://gathertown.notion.site/Gather-Websocket-API-bf2d5d4526db412590c3579c36141063](https://gathertown.notion.site/Gather-Websocket-API-bf2d5d4526db412590c3579c36141063)  
	- APIの詳細なドキュメント：[http://gather-game-client-docs.s3-website-us-west-2.amazonaws.com/index.html](http://gather-game-client-docs.s3-website-us-west-2.amazonaws.com/index.html)  

- gatherにいる人がslackからわかるプロダクト。DMとかもできるらしい：
	- [https://twitter.com/DRFR0ST/status/1510071716999049219](https://twitter.com/DRFR0ST/status/1510071716999049219)  
