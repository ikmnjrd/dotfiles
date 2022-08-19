#!/bin/bash
## respect to https://github.com/tanish-kr/dotfiles/blob/master/dotfiles.sh

# 読み込み用
# dotfiles=($(find `pwd` -mindepth 1 -maxdepth 2 -regex ".*\/\..*" \
#     -not -type d \
#     -not -name "*.DS_Store" \
#     -not -name "*.gitignore" \
#     -not -name "*.gitmodules" \
#     -not -name "*.git" \
#     -not -name "*.swp" \
#     -not -name "*.swo" \
#     -not -path "*/.git/*" \
#     -not -path "*/org/*"))
dotfiles+=("$(pwd)/.zshrc")
dotfiles+=("$(pwd)/.zshenv")
dotfiles+=("$(pwd)/.tmux.conf")
dotfiles+=("$(pwd)/.gitconfig")
dotfiles+=("$(pwd)/.alacritty.yml")
dotfiles+=("$(pwd)/vscode/keybindings.json")
dotfiles+=("$(pwd)/vscode/settings.json")

## 展開用
# home_dotsfile=($(find $HOME -maxdepth 1 -regex ".*\/\..*" \
#     -not -type d \
#     -not -name "*.DS_Store" \
#     -not -name "*.swp" \
#     -not -name "*.swo"))
home_dotsfile+=("$HOME/.zshrc")
home_dotfile+=("$HOME/.zshenv")
home_dotsfile+=("$HOME/.tmux.conf")
home_dotsfile+=("$HOME/.gitconfig")
home_dotsfile+=("$HOME/.alacritty.yml")
## vscode
if [ "$(uname)" == 'Darwin' ]; then
    home_dotsfile+=("$HOME/Library/Application Support/Code/User/keybindings.json")
    home_dotsfile+=("$HOME/Library/Application Support/Code/User/settings.json")
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux']; then
    home_dotsfile+=("$HOME/.config/Code/User/keybindings.json")
    home_dotsfile+=("$HOME/.config/Code/User/settings.json")
fi


## 未検証
## 分からない
# install() {
#   backup
#   git submodule update --init --recursive
#   set
# }

set() {
  for file_name in "${dotfiles[@]}"; do
    ### ./vscode ###
    if [[ $file_name =~ \/vscode\/.+\.json$ ]]; then
      if [ "$(uname)" == 'Darwin' ]; then
        ln -svf $file_name "$HOME/Library/Application Support/Code/User"
      elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux']; then
        ln -svf $file_name "$HOME/.config/Code/User"
      fi
    ### ./ ###
    else
      ln -svf $file_name $HOME
    fi
    echo "Set link to ${file_name}."
  done
}

unset() {
  for file_name in $(list); do
    unlink $file_name
    echo "Unlink to ${file_name}."
  done
}

## 未検証
# backup() {
#   for file_name in "${home_dotsfile[@]}"; do
#     cp -RH $file_name org/
#     echo "Backup to ${file_name}."
#   done
# }

## 動いてる??
list() {
  for file_name in "${home_dotsfile[@]}"; do
    link_path=$(readlink $file_name)
    if [ $(contains "${dotfiles[@]}" "$link_path") == "y" ]; then
      echo "$file_name"
    fi
  done
}

contains() {
  local n=$#
  local value=${!n}
  for ((i=1;i < $#;i++)) {
    if [[ "${!i}" =~ "${value}" ]]; then
      echo "y"
      return 0
    fi
  }
  echo "n"
  return 1
}

debug() {
  echo "dotfiles"
  echo ${dotfiles[@]}
  for file_name in "${dotfiles[@]}"; do
    echo "$file_name"
  done
  echo "home_dotfiles"
  echo ${home_dotsfile[@]}
  for file_name in "${home_dotsfile[@]}"; do
    echo "$file_name"
  done
}

help() {
  echo "Useage: $0 <install|update|delete|backup|list|help>"
  echo "  - install|-i:     Install dotfiles."
  echo "  - set|-s:         Set dotfiles."
  echo "  - unset|-u:       Un set dotfiles."
  echo "  - list|-l:        List dotfiles."
}

case $1 in
  debug)
    debug
    exit 0
    ;;
  install|-i)
    install
    exit 0
    ;;
  set|-s)
    set
    exit 0
    ;;
  unset|-u)
    unset
    exit 0
    ;;
  backup|-b)
    backup
    exit 0
    ;;
  list|-l)
    cnt=0
    for file_name in $(list); do
      echo "$file_name -> $(readlink $file_name)"
      let cnt++
    done
    echo "Total lists $cnt"
    exit 0
    ;;
  help|-h)
    help
    exit 0
    ;;
  *)
    help
    exit 1
    ;;
esac
