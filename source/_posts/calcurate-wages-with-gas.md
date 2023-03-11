---
title: バイトの月給をGASで計算
date: 2021-11-15 17:58:35
tags:
categories:
---

Google カレンダーにバイト用のカレンダーを作成し，そのカレンダーの時間合計から月給を計算します．
複数のバイト先に対応しています．コード１〜4 を別々のファイルにします．
デフォルトだと 31 日締めになっています．
これを web アプリとして公開して URL にアクセスすると，その度に計算をしなおします．

<!-- more -->

### コード１

```javascript:settings.gs
function cID(){
  return "hogehohgeohogehogheo@group.calendar.google.com"
}

function serchWord(){
  return ["バイトA","バイトB"]//何個でも増やせる
}

function jikyu(a){
  switch (a){
    case "バイトA":
    return 10000000 //時給を入力
    break;

    case "バイトB":
    return 100000000
    break;
  }
}
```

### コード２

```javascript
function doGet() {
  var template = HtmlService.createTemplateFromFile("index");
  template.thisM = sumReturn()[0];
  template.lastM = sumReturn()[1];
  template.value1 = value() * 100;
  var html = HtmlService.createHtmlOutputFromFile("index");
  var content = html.getContent().replace(/%value\(\)%/, '"' + value() + '"');
  HtmlService.createHtmlOutput(content);
  return template.evaluate();
}

function value() {
  CalendarApp.getDefaultCalendar();
  const calendarId = cID();
  const calendar = CalendarApp.getCalendarById(calendarId);

  const today = new Date();
  const year = today.getFullYear();
  const month = today.getMonth();

  var st = new Date(year, month, 1);
  var end = today;
  var events = calendar.getEvents(st, end);
  var untilToday = okaneKeisan(events);

  end = new Date(year, month, 31);
  st = new Date(year, month, 1);
  events = calendar.getEvents(st, end);
  var untilMisoka = okaneKeisan(events);
  return untilToday / untilMisoka; //今，今月の何割働いたかがわかる関数っぽい，HTMLに表示されてないけど
}
```

### コード３

```javascript
function sumReturn() {
  //初期状態を作るために使う
  CalendarApp.getDefaultCalendar();
  const calendarId = cID();
  const calendar = CalendarApp.getCalendarById(calendarId);

  const date1 = new Date();
  const year = date1.getFullYear();
  const month = date1.getMonth(); //0~11までの値を返す，8月なら7が帰ってくる
  const day = date1.getDay();

  //先月分
  var st = new Date(year, month - 1, 1);
  var end = new Date(year, month - 1, 31);
  var events = calendar.getEvents(st, end);
  var sumOfLast = okaneKeisan(events);
  //今月分
  st = new Date(year, month, 1);
  end = new Date(year, month, 31);
  events = calendar.getEvents(st, end);
  var sumOfThis = okaneKeisan(events);
  return [sumOfThis, sumOfLast];
}

function okaneKeisan(events) {
  var baito = serchWord();
  var kyuyo = [];
  var sum = 0;
  for (var i = 0; i < baito.length; i++) {
    var allTime = 0;
    var targetCount = 0;
    var baitosaki = baito[i];
    for (var count = 0; count < events.length; count++) {
      // カレンダーのタイトルでの絞り込みはできないので
      // 全てのイベントのタイトルで比較する。
      if (events[count].getTitle().indexOf(baitosaki) != -1) {
        targetCount++;
        var event_start = events[count].getStartTime(); //基準時からのミリ秒が取得できる
        var event_end = events[count].getEndTime();
        allTime += (event_end - event_start) / 1000;
      }
    }
    allTime /= 3600;
    kyuyo[i] = allTime * jikyu(baitosaki);
    sum += kyuyo[i];
  }
  return sum;
}
```

### コード４

```html
<!DOCTYPE html>
<html>
  <head>
    <base target="_top">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.3/css/bulma.min.css">
  </head>
  <body>
    <div class="title hero is-link">給与計算</div>
    <div class="tile is-ancestor">
      <div class="tile is-vertical">
        <div class="tile box">
          <p class="title">今月の給与</p>
          <p><?=thisM?>円</p>
        </div>
      <div class="tile box">
        <p class="title">先月の給与</p>
        <p><?=lastM?>円</p>
      </div>
    </div>
  </div>
</div>
<script type="text/javascript">
  const bar = document.getElementbyId("bar").value;
  const per = document.getElementbyId("per").innerHTML.substr( 4, 4 );
  bar = per;
  console.log(per.innerHTML.substr( 4, 4 ));
  </script>
  </body>
</html>
```
