# git-propmtの読み込み
source ~/.zsh/git-prompt.sh

# git-completionの読み込み
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash

# zshの補完機能を有効にする
autoload -Uz compinit && compinit


# プロンプトのオプション表示設定
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto


# PROMPT_COMMAND
setopt PROMPT_SUBST ; PS1='[%n@%m %c$(__git_ps1 " (%s)")]\$ '
export PATH="/usr/local/sbin:$PATH"

## alias
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias cat='bat --paging=never'

## fzfインストール時に自動追加
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
## fzf設定
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "bat  --color=always --style=header,grid --line-range :100 {}"'
# fbr - checkout git branch
fbr() {
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