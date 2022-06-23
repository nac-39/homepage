---
title: JupyterでC++を動かしたい
date: 2021-11-17 02:11:55
tags:
categories:
---

## 一番言いたいこと
`clingのインストール先/share/Jupyter/kernel`じゃなくて，
`/src/tools/cling/tools/Jupyter/kernel`
だ！！！！！
## 目的など
Jupyter labでC++を使いたい！！！！
仕組みとしては，ClingというC++をインタプリタみたいに動かす環境をJupyterでも動くようにしてる感じ．
先に断っておくと，急いで書いたので言葉足らず感があります．すみません．リンク先が詳しいので，ぜひ参照してください．
## インストール方法
とりあえず自分がやった方法を示しておく．
1. [このサイト](https://root.cern/cling/cling_build_instructions/)のManual buildを参考に，
```bash
git clone http://root.cern/git/llvm.git src
cd src
git checkout cling-patches
cd tools
git clone http://root.cern/git/cling.git
git clone http://root.cern/git/clang.git
cd clang
git checkout cling-patches
cd ../..
```
2. Cmakeを使ってbuildする．2時間近くかかったので，覚悟が必要．多分バイナリファイルをダウンロードしておけばこの工程いらない．CmakeがPCに入っていない人はCmakeをダウンロードする必要が…(バイナリファイルをダウンロードしろ！もしくは`brew install cling`で入れちゃえ)
`/usr/local/bin/`配下に適当なファイル作ってそこを`[Install Path]`にした．`Release or Debug`は`Release`を選んだ．
```bash
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=[Install Path] -DCMAKE_BUILD_TYPE=[Build configuration, e.g. Release or Debug] ..\src
cmake --build .
cmake --build . --target install
```
3. [GitHubのここ](https://github.com/root-project/cling/blob/f84e601d3f5cfd06f4b557780ca62e68d2cfa473/tools/Jupyter/README.md)にあるように，パスを通してから諸々実行する．
**ここで注意！**
`clingのインストール先/share/Jupyter/kernel`じゃなくて，
`どこか/src/tools/cling/tools/Jupyter/kernel`に`cd`する！（ちなみにcling-install-prefixはclingをインストールした場所のパスって意味で，任意で自分で変えるところだよ！prefixは接頭辞みたいな意味）
↓諸々実行するやつ．
```bash:諸々実行するやつ
export PATH=/cling-install-prefix/bin:$PATH
cd /cling-install-prefix/share/cling/Jupyter/kernel

pip install -e .
# or: pip3 install -e .

# register the kernelspec for C++17/C++1z/C++14/C++11:
# the user can install whichever kernel(s) they
# wish:
jupyter-kernelspec install --user cling-cpp17
jupyter-kernelspec install --user cling-cpp1z
jupyter-kernelspec install --user cling-cpp14
jupyter-kernelspec install --user cling-cpp11

```
これで`jupyter notebook`したらカーネルにC++が出現してる！はず！

## 分かってないのでぜひ教えてほしいこと
- Clingの実体 = `brew install cling`でインストールされるもの = buildしたらできるもの => バイナリファイル（とその他諸々）
って言う認識でOK？
- GitHubからクローンしてきた奴らは何？`jupyter-kernelspec install --user cling-cpp17`これはどう言う意味のコマンド？
- そもそもAnacondaでやった方が楽(((([参考記事](https://buttai-k.hatenablog.com/entry/2020/12/05/220000_1)
- LLVMってなんですか！なんでCERNが作ってるんですか！

## 参考記事
- [JupyterにC++のノートのためのclingカーネルを追加する [Mac]](https://qiita.com/sasaki77/items/f6253e1d6638fba0e744)
途中まではいっしょなんだけど，buildがうまくいかんかった
- [GitHub: root-project/cling](https://github.com/root-project/cling)
- [C++11/14/17インタプリタ環境 Jupyter-Cling](https://qiita.com/mugwort_rc/items/b8087d1b6f9498b037d5)
この記事の言う通り，バイナリダウンロードした方がいいよ，絶対！
- [Interactive C++: Jupyter上で対話的にC++を使う方法の紹介](https://r9y9.github.io/blog/2017/12/21/jupyter-cxx/)
四つのC++のインタプリタ環境についてまとめてある！

