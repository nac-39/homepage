---
title: nuctのカレンダーをmicrosoft ToDoに自動追加する（GUIのみでできる！）
date: 2022-01-29 19:22:55
tags:
---

# 手順

## 1. NUCT のカレンダーからリンクを取得する

1. ホームのカレンダーから，公開（プライベート）
2. 個人用にこのカレンダーにリンクを生成する，の下側のリンクをコピーする
<!-- more -->

## 2. Microsoft Outlook にカレンダーを追加する

1. https://outlook.office.com/calendar/addcalendar にアクセスする（サインインしてなかったら，サインインが求められます）
2. Web から定期受信を選び，先程の URL をコピペする
3. 諸々の設定をして保存

## 3. Microsoft To-Do にリストを追加する

(注意:Microsoft には To-Do と Planner というサービスがあって，これらは別のものです．)

1. https://to-do.office.com/tasks/today　にアクセスする．
2. 「新しいリスト」から作成

## 4. Microsoft Power Automate の設定をする

1. https://powerautomate.microsoft.com/ja-jp/ にアクセス,　サインインする．
2.
3. Outlook のトリガー，「When a new event is created」を選択
4. 予定表 ID を設定．
5. Microsoft To-Do のアクション，「To Do を追加する」を追加．
6. To Do リスト，タイトル，期日などを設定する．タイトル以下は動的なコンテンツからカレンダーの情報を取得して入れる．
   ![一例](/images/automate1.png)
7. 保存する
