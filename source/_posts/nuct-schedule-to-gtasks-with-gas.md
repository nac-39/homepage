---
title: GASでNUCTのスケジュールをタスクに変換する
date: 2021-08-10 14:40:56
tags: ["GAS", "Coding", "JavaScript", "NUCT"]
categories: NUCT
---

# 手順

1. NUCT から Google カレンダーにエクスポートする
2. コードを GoogleSpreadSheet のエディタにコピペする
3. コードを実行する
<!-- more -->

# 1.NUCT→Google カレンダーにエクスポート

1. NUCT>スケジュール>公開（プライベート）> https から始まるリンクをコピー
1. Google カレンダー > 他のカレンダーの横の＋ > URL で追加 > URL をペースト

# 2.コードを GoogleSpreadSheet のエディタにコピペする

1. スプレッドシートを新規作成>ツール>スクリプトエディタ
1. サービス > Tasks API を選択、追加
1. ファイルの＋から新しいスクリプトを 3 つ追加 > スクリプトの名前を上から 1,2,3,4 にする
1. 下記のコード 1~4 を GAS 上のスクリプト 1~4 にコピペ

### コード１：初期状態を作るために使う

```
function henkan(today) {
                  //Tue Apr 13 2021 19:00:00 GMT+0900(Japan Standard Time)となっている日時をRFC3339方式（2021-04-13T19:00:00_00.000+0900)に変換
                  timex = Utilities.formatDate(today,"JST", "HH:mm:ss")
                  datex = Utilities.formatDate(today,"JST", "yyyy-MM-dd");
                  hiduke = datex + "T" + timex + ".000+09:00" ;
                  return(hiduke);
                }

                function Getnow() {
                  var d = new Date();
                  var y = d.getFullYear();
                  var mon = d.getMonth() + 1;
                  var d2 = d.getDate();
                  var h = d.getHours();
                  var min = d.getMinutes();
                  var s = d.getSeconds();
                  var now = y+"/"+mon+"/"+d2+" "+h+":"+min+":"+s;
                  return now;
                }


                function setup() {
                  //初期状態を作るために使う
                  CalendarApp.getDefaultCalendar();
                  const calendarId = cID();
                  const calendar = CalendarApp.getCalendarById(calendarId);
                  const taskListId = tID();

                  const startdate = new Date('2021/5/9');//カレンダーのイベントを読み込み始める日付
                  const enddate = new Date('2029/12/31');
                  const events = calendar.getEvents(startdate,enddate);

                  for(const event of events){
                    let titleEvent = event.getTitle();
                    let description = event.getDescription();
                    let shimekiri = henkan(event.getEndTime());

                    var task = {
                        title: titleEvent, //  タイトル
                        notes: description, // メモ
                        due: shimekiri // 締切日。日付のフォーマットはRFC3339に準拠
                      };
                      task = Tasks.Tasks.insert(task, taskListId);
                      Logger.log("新しいタスクのID：" + task.id);

                  }
                  const sheet = SpreadsheetApp.getActiveSheet();
                  const cell = sheet.getRange(sheet.getLastRow()+1,1);
                  cell.setValue(Getnow());
                  }
```

### コード２：タスクいじる関連です。

```
function getTaskLists() {
              var taskLists = Tasks.Tasklists.list().getItems();
              if (!taskLists) {
                return [];
              }
              return taskLists.map(function(taskList) {
                return {
                  id: taskList.getId(),
                  name: taskList.getTitle()
                };
              });
            }

            function viewAllList(){
              var myTaskLists = getTaskLists();
              let i =0;
              for(const j of myTaskLists){
              Logger.log( myTaskLists[i].id);
              Logger.log( myTaskLists[i].name);
              i++;
              }
            }

            function callListTasks(){
              const myTaskListId = listTaskLists();
              listTasks(myTaskListId);
            }

            function listTaskLists() {
              //タスクリストのidと名前を返す
              let taskLists = Tasks.Tasklists.list();
              if (taskLists.items) {
                let peach = [[],[]];
                Logger.log(taskLists.items.length);
                for (let i = 0; i < taskLists.items.length; i++) {
                  let taskList = taskLists.items[i];
                  peach[i] = [taskList.id,taskList.title];
                }
                return peach;
              } else {
                Logger.log('Sorry, No task lists found.');
                return "none";
              }

            }

            function listTasks(taskListId) {
              //あるタスクリストの中のタスクの一覧を返す
              let tasks = Tasks.Tasks.list(taskListId);
              if (tasks.items) {
                console.log(tasks.items.length);
                let taskReturn = [];
                for (let i = 0; i < tasks.items.length; i++) {
                  let task = tasks.items[i];
                  taskReturn[i] = task.title;
                }
                return taskReturn;
              } else {
                Logger.log('Sorry, No tasks found.');
                return "none";
              }
            }

            function view(){
              array = listTaskLists();
              let j=0;
              for(i of array){
              Logger.log(listTasks(array[j][0]));
              j++;
              }
            }

            function viewAllListInSheet(){
              const sheet = SpreadsheetApp.getActiveSheet();
              var myTaskLists = getTaskLists();
              let i =0;
              for(const j of myTaskLists){
                let cell = sheet.getRange(i+1,6);
                cell.setValue( myTaskLists[i].id);
                cell = sheet.getRange(i+1,7);
                cell.setValue( myTaskLists[i].name);
                i++;
              }
            }

```

### コード３：更新するために使います。改善の余地あり。

```
 function update() {
              CalendarApp.getDefaultCalendar();
              const sheet = SpreadsheetApp.getActiveSheet();
              const calendarId = cID();
              const calendar = CalendarApp.getCalendarById(calendarId);
              const taskListId = tID();

              const startdate = new Date('2021/5/1');
              const enddate = new Date('2030/12/31');
              const events = calendar.getEvents(startdate,enddate);
              const cell = sheet.getRange(sheet.getLastRow(),1);
              let lastUpdate = new Date(cell.getValue());
              lastUpdate = lastUpdate.getTime();

              for(const event of events){
               console.log(event.getTitle()  + ":" +event.getDateCreated())
               let whenNewEvent = event.getDateCreated().getTime();
               //この判定方法やめた方がいいんかな
               //ある予定が作成された日時と最終更新日時を比べて、追加するようにしている

               let bool = lastUpdate < whenNewEvent;

               if(bool == true){
                 let titleEvent = event.getTitle();
                 let description = event.getDescription();
                 let shimekiri = henkan(event.getEndTime());

                  var task = {
                    title: titleEvent, //  タイトル
                    notes: description + "from update script", // いらんかったら消してね
                    due: shimekiri // 締切日。日付のフォーマットはRFC3339に準拠
                  };

                 //コンソールに書き出す
                 task = Tasks.Tasks.insert(task, taskListId);
                 Logger.log("新しいタスクのID：" + task.id);

                 //スプレッドシートに更新日時を書き足す
                 const cell = sheet.getRange(sheet.getLastRow()+1,sheet.getLastColumn());
                 cell.setValue(Getnow());
               }
              }

             }
```

### コード４:ID を登録するのに使います。

※ID はカレンダーやタスクのリスト一つ一つに割り振られています。

```
     function tID() {
              const sheet = SpreadsheetApp.getActiveSheet();
              let cell = sheet.getRange('B1');
              let tID = cell.getValue();
              return tID;
            }

            function cID() {
              const sheet = SpreadsheetApp.getActiveSheet();
              let cell = sheet.getRange('B2');
              let cID = cell.getValue();
              return cID;

            }
```

# 実行する

1. カレンダー ID を調べる。google カレンダ > オーバーフローメニュー > 設定 > カレンダーを結合 > カレンダー ID
1. カレンダー ID をスプレッドシートの B2 にペースト
1. スクリプト 2 を開き、viewAllListInSheet を選択、実行する。
1. スプレッドシートにタスク ID 一覧が表示されるので、選んで B1 にペースト
1. スクリプト 1 を開く。setup を選択、実行する。
1. 更新したい時はスクリプト 3 をから update を選択、実行する。
