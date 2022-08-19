. "$HOME/.cargo/env" # 「.」はsourceと同義

## aliases
alias ll="ls -al"
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias cat='bat --paging=never'
alias day='date "+%Y-%m-%d"'
alias fcode='code $( locate .git | grep "\.git$" | sed "s/\/\.git$//g" | fzf)'
alias updatedb='sudo /usr/libexec/locate.updatedb' # locateコマンドの辞書作成
# tree参考:https://gist.github.com/jpwilliams/dabff82b0ceb95dd57a7552ea7f2d675
alias tree='tree -C -I $((cat .gitignore 2> /dev/null || cat $(git rev-parse --show-toplevel 2> /dev/null)/.gitignore 2> /dev/null || echo "node_modules") | egrep -v "^#.*$|^[[:space:]]*$" | tr "\\n" "|" | rev | cut -c 2- | rev)'


