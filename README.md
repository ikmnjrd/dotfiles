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

`bin/remote-dev` は、このPCまたはMacのカレントGit worktreeを
`nixos.local`へrsyncします。
NixOS側では同期先へ移動して、Docker Composeや`nix develop`を直接実行します。

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

使うときは対象リポジトリまたはworktreeで実行します。

```sh
git worktree add ../example-feature -b feature/example
cd ../example-feature
remote-dev
ssh nixos-remote-dev
cd ~/workspace/remote-dev/<host>/<repo>/feature-example
docker compose up
```

同期先は`~/workspace/remote-dev/<host>/<repo>/<branch>/`です。
`<repo>`は`remote.origin.url`のリポジトリ名から決め、remoteが無い場合はworktreeのディレクトリ名を使います。
`<host>`、`<repo>`、`<branch>`は小文字化し、ディレクトリ名として扱いやすい形に正規化します。
detached HEADはサポートしません。

ソースはホスト側が正本です。
同期には`rsync --delete`を使うため、NixOS側の実行コピーを直接編集しないでください。
`.env`や`.env.local`などのGit管理外ファイルも同期されます。
リモート側だけに置きたい一時ファイルは`.remote-dev-local/`に置きます。

# お気持ち
## Color Scheme

[x] Nord

## .zshrcと.zshenvの使い分け

vim内部からzshの設定ファイルに記述したエイリアスを使用したいなら、vimrc(./.confing/nvim/init.vim)にzshを使う旨を記述`set shell=zsh`する  
vim内部ではzshをログインシェルとして呼ばないため(?)、.zshenvまでしか読み込まないみたい。  
そのため、エイリアスは`.zshenv`に、基本は`.zshrc`に記述する方針  
