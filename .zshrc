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