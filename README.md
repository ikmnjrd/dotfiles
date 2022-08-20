
## Linux
1. ./install-via-pacman.
2. ./deploy
3. source ~/.zshrc

## Mac
1. ./zshrc
3. source ~/.zshrc

## .zshrcと.zshenvの使い分け
vim内部からzshの設定ファイルに記述したエイリアスを使用したいなら、vimrc(./.confing/nvim/init.vim)にzshを使う旨を記述`set shell=zsh`する  
vim内部ではzshをログインシェルとして呼ばないため(?)、.zshenvまでしか読み込まないみたい。  
そのため、エイリアスは`.zshenv`に、基本は`.zshrc`に記述する方針  

## Favorite Color Scheme
[x] Nord

## ターミナル
### iTerm2
結局これになってしまった。設定が複雑&持ち出しづらいのであまり使いたくない。その複雑さからか、デフォルトでマウスホイールで履歴を遡れるがtmuxのオプションがいくつか効かなくなってつらい。なのでtmuxを諦めてiTerm2の機能の画面分割に落ち着いている。  
使用カラースキーマ: [Nord-iterm2](https://github.com/arcticicestudio/nord-iterm2/blob/develop/README.md)

### alacritty
シンプルで設定ファイルの管理しやすさなどからalacrittyが好ましいが日本語入力時に確定するまで表示できない点から候補落ち。ここが改善されればすぐ使う。
