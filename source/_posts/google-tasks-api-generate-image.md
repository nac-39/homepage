---
title: Google Tasks api 叩いてpillowでデスクトップ画像生成
date: 2021-10-21 00:33:23
tags:
categories:
---

# やりたいこと

Tasks をパソコンのデスクトップ画面に表示したい

<!-- more -->

# やったこと．

### Python で Tasks API を叩く

API 叩くのはよくわからないので，以下のリンクの quickstart.py をコピペしてくる．
https://developers.google.com/tasks/quickstart/python

しかし，quickstart.py を実行したら，`credentials.json`がないと言われた.

https://github.com/googleworkspace/python-samples/issues/211

この issue に解決方法が書いてあった．要するに OAuth の認証情報を Google Cloud Platform で作って，それを json 形式でダウンロードしておかないといけなかったらしい．

quickstart.py を実行するとタスクリストの名前と id が出てくるので，それを以下のコードの`tasklist="task id"`に入れたら，タスクの一覧がとってこれる．
この辺の詳細は[Google Tasks API PyDoc documentation](https://developers.google.com/resources/api-libraries/documentation/tasks/v1/python/latest/index.html)をみよう．

```python
# Call the Tasks API
    results = service.tasklists().list(maxResults=10).execute()
    items = results.get('items', [])

    task_list = service.tasks().list(tasklist="task id").execute()
```

### pillow で画像を生成する

コード貼っとくので，適当に改良して使って（このコード自体八割コピペ）

ちょっと解説

- `img = Image.new(mode, size color=(0,0,0))`で新しく単一色の画像を生成してる．
- フォントのパスはデフォルトで入ってるのは`/System/Library/Fonts/hogehoge.ttc`だけど，自分で追加したやつは`/Users/ユーザー名/Library/hogehoge.ttf`になる．
- フォントは文字ごとに高さが違うらしいので，文字の高さを基準に描画しない方がいい
- `draw.text((x,y), 文字, font=フォント, fill=(R,G,B))`で文字を描画する．
- 色の指定にはカラーピッカーで検索すると便利．
- `strftime`の引数は[ここ](https://note.nkmk.me/python-datetime-usage/#_1)を参照．

```Python
def createImage(items): #items = [[タイトル,締切日時],[タイトル,締切日時]...]
    #img = Image.open('bg.png').copy() # 入力ファイルを指定
    img = Image.new("RGB", (2500,1600), color=(22, 26, 59))
    imagesize = img.size        # img.size[0]は幅、img.size[1]は高さを表す
    draw = ImageDraw.Draw(img)  # ImageDrawオブジェクトを作成

    font1 = ImageFont.truetype("/System/Library/Fonts/ヒラギノ角ゴシック W3.ttc", 64)  # フォントを指定、64はサイズでピクセル単位
    font2 = ImageFont.truetype("/System/Library/Fonts/ヒラギノ角ゴシック W3.ttc", 48)  # フォントを指定、64はサイズでピクセル単位
    count = 0
    for text, due in items:
        size1 = font1.getsize(text)
        size2 = font2.getsize(text)
        tate = 131 #dueとtitle合わせた高さ，適当に決めた．
        draw.text((10, 80 + count * tate), due, font=font2, fill=(174, 196, 230))
        draw.text((64, 80 + count * tate+ size2[1] +10), text, font=font1, fill='#FFF')
        count += 1
        if count > 10:#10個だけを表示する．
            break
    #画像の生成日時も入れる．
    now = datetime.datetime.now().strftime("%b %d %H:%M")
    draw.text((10,imagesize[1]-48),now,font=font2,fill=(145,145,145))
    # ファイルを保存
    img.save('new_bg.png', 'PNG', quality=100, optimize=True)
```

### コマンドで壁紙を設定できるようにする．

- `wallpaper`っていうコマンドを homebrew でインストールして使った．他にも OS の壁紙が保存してあるディレクトリに画像を直接追加する方法もあるみたい．

```bash
brew install wallpaper
wallpaper set ./hogehoge.png
```

これで hogehoge.png が今いるデスクトップの壁紙になった．また，パソコンを立ち上げた時のログイン画面の壁紙もこれになる．

シェルのコマンドを Python から使うために，`subprocess`モジュールを使う．
詳しくはググって欲しい．試行錯誤の末，これならうまく行った．

```python
subprocess.run(["wallpaper set 生成した画像への絶対パス"],shell=True)
```

### 定期的に実行する．

定期的に実行するためには，`schedule`モジュールを使う．

schedule の基本の型はこんなかんじ

```python
import schedule

def job():
    #一回の動作でやること
    hogehoge()
#1時間毎のjob実行を登録
schedule.every(1).hour.do(job)
#hour->minuteとかに変えられる
while True:
    schedule.run_pending()
    time.sleep(30)
```

`while True:`がないと一回限りで終わってしまう．

### これをいい感じに組み合わせると完成！！！！！！！！！

動けばいいやのクソコードなので公開はしないかな
タスク管理ツールは作る気力があるのにタスクをやる気が起きません…………
