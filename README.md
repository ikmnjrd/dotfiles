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

## NixOS remote development

`bin/remote-dev` は、このPCまたはMacのGit worktreeを
`nixos.local`へ一方向同期し、NixOS側でDocker Composeまたは
`nix develop`の開発サーバーを起動します。

初回だけホスト別の鍵を作成し、公開鍵をnixos-configへ追加します。

```sh
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_nixos_remote_dev
./deploy.sh set
remote-dev doctor
```

Arch LinuxではmDNS解決のため、Avahiも有効化します。

```sh
sudo systemctl enable --now avahi-daemon
getent hosts nixos.local
```

解決できない場合は `/etc/nsswitch.conf` の `hosts:` に
`mdns_minimal [NOTFOUND=return]` が含まれていることを確認します。

Webリポジトリでは `examples/remote-dev` を参考に
`.remote-dev.json` を作成します。Composeの公開ポートは、たとえば
`127.0.0.1:${REMOTE_DEV_WEB_PORT:-3000}:3000` のように設定ファイルで
指定した環境変数を受け取る必要があります。

```sh
git worktree add ../example-feature -b feature/example
cd ../example-feature
remote-dev init feature
remote-dev secrets sync
remote-dev up
remote-dev status
remote-dev logs --follow
remote-dev down
remote-dev destroy
```

ソースはホスト側が正本です。NixOS側の実行コピーを直接編集しないでください。

# お気持ち
## Color Scheme

[x] Nord

## .zshrcと.zshenvの使い分け

vim内部からzshの設定ファイルに記述したエイリアスを使用したいなら、vimrc(./.confing/nvim/init.vim)にzshを使う旨を記述`set shell=zsh`する  
vim内部ではzshをログインシェルとして呼ばないため(?)、.zshenvまでしか読み込まないみたい。  
そのため、エイリアスは`.zshenv`に、基本は`.zshrc`に記述する方針  
