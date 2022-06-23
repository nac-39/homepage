---

title: nuctのカレンダーをmicrosoft ToDoに自動追加する（GUIのみでできる！）
date: 2022-01-29 19:22:55
tags:
---

# 手順

## 1. NUCTのカレンダーからリンクを取得する
1. ホームのカレンダーから，公開（プライベート）
2. 個人用にこのカレンダーにリンクを生成する，の下側のリンクをコピーする

## 2. Microsoft Outlookにカレンダーを追加する
1. https://outlook.office.com/calendar/addcalendar にアクセスする（サインインしてなかったら，サインインが求められます）
2. Webから定期受信を選び，先程のURLをコピペする
3. 諸々の設定をして保存

## 3. Microsoft To-Doにリストを追加する
(注意:MicrosoftにはTo-DoとPlannerというサービスがあって，これらは別のものです．)
1. https://to-do.office.com/tasks/today　にアクセスする．
2. 「新しいリスト」から作成

## 4. Microsoft Power Automateの設定をする
1. https://powerautomate.microsoft.com/ja-jp/ にアクセス,　サインインする．
2. 
3. Outlookのトリガー，「When a new event is created」を選択
4. 予定表IDを設定．
4. Microsoft To-Doのアクション，「To Doを追加する」を追加．
5. To Doリスト，タイトル，期日などを設定する．タイトル以下は動的なコンテンツからカレンダーの情報を取得して入れる．
![一例](/images/automate1.png)
6. 保存する