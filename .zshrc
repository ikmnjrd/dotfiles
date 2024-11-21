# git-propmtの読み込み
source ~/.zsh/git-prompt.sh

# git-completionの読み込み
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash

# zshの補完機能を有効にする
autoload -Uz compinit && compinit

# キーリピートの速度変更
xset r rate 300 50

# プロンプトのオプション表示設定
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto


# PROMPT_COMMAND
setopt PROMPT_SUBST ; PS1='[%n@%m %c$(__git_ps1 " (%s)")]\$ '
export PATH="/usr/local/sbin:$PATH"


# history設定
HISTFILE=~/.zsh_history
HISTSIZE=10000              # メモリ上で保持する最大件数
SAVEHIST=10000              # ファイルに保持する最大件数
setopt APPEND_HISTORY       # 履歴を追記
setopt INC_APPEND_HISTORY   # コマンド実行後に履歴を即日以下
setopt SHARE_HISTORY        # 全セッション間で履歴を共有
setopt EXTENDED_HISTORY     # 履歴にタイムスタンプを記録

## bat設定
export BAT_THEME="Nord"

## fzfインストール時に自動追加
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
## fzf設定
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "bat --color=always --style=header,grid --line-range :100 {}"'
# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
bindkey "ç" fzf-cd-widget # for Mac, keybinding option+c sends ç
# for My EndavourOS https://github.com/junegunn/fzf/issues/1190
source /usr/share/fzf/key-bindings.zsh

# fbr - checkout git branch
function fbr() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}
# # fbr - checkout git branch
# function fzf-checkout-branch() {
#   local branches branch
#   branches=$(git branch | sed -e 's/\(^\* \|^  \)//g' | cut -d " " -f 1) &&
#   branch=$(echo "$branches" | fzf --preview "git show --color=always {}") &&
#   git checkout $(echo "$branch")
# }
# zle     -N   fzf-checkout-branch
# bindkey "^b" fzf-checkout-branch

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    if ! IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                                COMP_LINE="$COMP_LINE" \
                                COMP_POINT="$COMP_POINT" \
                                npm completion -- "${words[@]}" \
                                2>/dev/null)); then
      local ret=$?
      IFS="$si"
      return $ret
    fi
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                  COMP_LINE=$BUFFER \
                  COMP_POINT=0 \
                  npm completion -- "${words[@]}" \
                  2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    if ! IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                            COMP_LINE="$line" \
                            COMP_POINT="$point" \
                            npm completion -- "${words[@]}" \
                            2>/dev/null)); then

      local ret=$?
      IFS="$si"
      return $ret
    fi
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###

### volta(node package manager)
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VOLTA_FEATURE_PNPM=1

### for auto-commit
export PATH="$PATH:$HOME/.bin"

### for Rust
export PATH="$HOME/.cargo/bin:$PATH"
