# 構築
## Linux

1. ./install-via-pacman.
2. ./deploy
3. source ~/.zshrc

## Mac

1. ./zshrc
2. source ~/.zshrc


## Homebrew

[manpage](https://docs.brew.sh/Manpage#bundle-subcommand)

# 運用
`.alacritty.toml`などのファイル内部でOSごとの設定を切り替えられないものは`.alacritty.linux.toml`や`.alacritty.osx.toml`としてそれぞれ管理する

# お気持ち
## Color Scheme

[x] Nord

## .zshrcと.zshenvの使い分け

vim内部からzshの設定ファイルに記述したエイリアスを使用したいなら、vimrc(./.confing/nvim/init.vim)にzshを使う旨を記述`set shell=zsh`する  
vim内部ではzshをログインシェルとして呼ばないため(?)、.zshenvまでしか読み込まないみたい。  
そのため、エイリアスは`.zshenv`に、基本は`.zshrc`に記述する方針  
