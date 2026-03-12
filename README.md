# 構築
## Linux

1. ./install-via-pacman.sh
2. ./deploy.sh set
3. source ~/.zshrc

## Mac

1. brew bundle --file Brewfile
2. ./deploy.sh set
3. source ~/.zshrc


## Homebrew

[manpage](https://docs.brew.sh/Manpage#bundle-subcommand)

# 運用
ターミナルは `wezterm` を使う。設定は [`.wezterm.lua`](/Users/ike/workspace/dotfiles/.wezterm.lua) で OS ごとに分岐する。既存の `.alacritty.*` は退避用として残してある。

# お気持ち
## Color Scheme

[x] Nord

## .zshrcと.zshenvの使い分け

vim内部からzshの設定ファイルに記述したエイリアスを使用したいなら、vimrc(./.confing/nvim/init.vim)にzshを使う旨を記述`set shell=zsh`する  
vim内部ではzshをログインシェルとして呼ばないため(?)、.zshenvまでしか読み込まないみたい。  
そのため、エイリアスは`.zshenv`に、基本は`.zshrc`に記述する方針  
