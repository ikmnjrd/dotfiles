#!/bin/bash
## respect to https://github.com/tanish-kr/dotfiles/blob/master/dotfiles.sh


is_mac=$([ "$(uname)" == 'Darwin' ] && echo "true" || echo "false")

is_linux=$([ "$(expr substr $(uname -s) 1 5)" == 'Linux' ] && echo "true" || echo "false")

echo "a: $is_mac"
echo "b: $is_linux"

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
dotfiles+=("$(pwd)/.config/nvim/init.vim")
dotfiles+=("$(pwd)/.config/espanso/config/default.yml")
dotfiles+=("$(pwd)/.config/espanso/match/base.yml")
dotfiles+=("$(pwd)/.config/espanso/match/coding.yml")
dotfiles+=("$(pwd)/.config/espanso/match/markdown.yml")
dotfiles+=("$(pwd)/.config/espanso/match/arrow.yml")
dotfiles+=("$(pwd)/.config/espanso/match/apple-symbol.yml")
dotfiles+=("$(pwd)/.config/espanso/match/curl.yml")
dotfiles+=("$(pwd)/.config/espanso/match/hax.yml")
dotfiles+=("$(pwd)/.config/espanso/match/all-emoji.yml")
dotfiles+=("$(pwd)/vscode/keybindings.json")
dotfiles+=("$(pwd)/vscode/settings.json")
if [ "$is_mac" == "true" ]; then
    dotfiles+=("$(pwd)/.yabairc")
    dotfiles+=("$(pwd)/.skhdrc")
    dotfiles+=("$(pwd)/.alacritty.osx.toml")
elif [ "$is_linux" == "true" ]; then
    dotfiles+=("$(pwd)/.alacritty.linux.toml")
fi


## 展開用
# home_dotsfile=($(find $HOME -maxdepth 1 -regex ".*\/\..*" \
#     -not -type d \
#     -not -name "*.DS_Store" \
#     -not -name "*.swp" \
#     -not -name "*.swo"))
home_dotsfile+=("$HOME/.zshrc")
home_dotsfile+=("$HOME/.zshenv")
home_dotsfile+=("$HOME/.tmux.conf")
home_dotsfile+=("$HOME/.gitconfig")
home_dotsfile+=("$HOME/.alacritty.toml")
home_dotsfile+=("$HOME/.config/nvim/init.vim")
## OS X
if [ "$is_mac" == "true" ]; then
    ## yabai
    home_dotsfile+=("$HOME/.yabairc")
    home_dotsfile+=("$HOME/.skhdrc")
    ## vscode
    home_dotsfile+=("$HOME/Library/Application Support/Code/User/keybindings.json")
    home_dotsfile+=("$HOME/Library/Application Support/Code/User/settings.json")
## Linux
elif [ "$is_linux" == "true" ]; then
    ## vscode
    home_dotsfile+=("$HOME/.config/Code/User/keybindings.json")
    home_dotsfile+=("$HOME/.config/Code/User/settings.json")
    home_dotsfile+=("$HOME/.config/espanso/config/default.yml")
    home_dotsfile+=("$HOME/.config/espanso/match/base.yml")
    home_dotsfile+=("$HOME/.config/espanso/match/coding.yml")
    home_dotsfile+=("$HOME/.config/espanso/match/markdown.yml")
fi


## 未検証
## 分からない
# install() {
#   backup
#   git submodule update --init --recursive
#   set
# }

set_links() {
  for file_name in "${dotfiles[@]}"; do
    ### ./vscode ###
    if [[ "$file_name" =~ \/vscode\/.+\.json$ ]]; then
        if [ "$(uname)" == 'Darwin' ]; then
            ln -svf "$file_name" "$HOME/Library/Application Support/Code/User"
        elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
            ln -svf "$file_name" "$HOME/.config/Code/User"
        fi
    ### nvim ###
    elif [[ "$file_name" =~ \/\.config\/nvim.+$ ]]; then
        ln -svf "$file_name" "$HOME/.config/nvim/"
    ### espanso ###
    elif [[ "$file_name" =~ \/\.config\/espanso/config.+$ ]]; then
        if [ "$is_mac" == "true" ]; then
            ln -svf "$file_name" "$HOME/Library/Application Support/espanso/config/"
        else
            ln -svf "$file_name" "$HOME/.config/espanso/config/"
        fi
    elif [[ "$file_name" =~ \/\.config\/espanso/match.+$ ]]; then
        if [ "$is_mac" == "true" ]; then
            ln -svf "$file_name" "$HOME/Library/Application Support/espanso/match/"
        else
            ln -svf "$file_name" "$HOME/.config/espanso/match/"
        fi
    ### alacritty ### 
    elif [[ "$file_name" =~ \/.alacritty.+$ ]]; then
        ln -svf "$file_name" "$HOME/.alacritty.toml"
    ### ./ ###
    else
      ln -svf "$file_name" "$HOME"
    fi
    echo "Set link to ${file_name}."
  done
}

unset() {
  for file_name in $(list); do
    unlink "$file_name"
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
    set_links
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
