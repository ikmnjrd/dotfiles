## Python
#alias python='/usr/bin/python3'

## 秘密鍵
if [ -f ~/.secrets ]; then
    source ~/.secrets
fi

## aliases
alias g="git"
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias cat='bat --paging=never'
alias day='date "+%Y-%m-%d"'
alias fcode='code $( locate .git | grep "\.git$" | sed "s/\/\.git$//g" | fzf)'
alias updatedb='sudo /usr/libexec/locate.updatedb' # locateコマンドの辞書作成
# tree参考:https://gist.github.com/jpwilliams/dabff82b0ceb95dd57a7552ea7f2d675
alias tree='tree -C -I $((cat .gitignore 2> /dev/null || cat $(git rev-parse --show-toplevel 2> /dev/null)/.gitignore 2> /dev/null || echo "node_modules") | egrep -v "^#.*$|^[[:space:]]*$" | tr "\\n" "|" | rev | cut -c 2- | rev)'

alias his='fc -l -t "%Y-%m-%d %H:%M:%S "'
alias icloud="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs"
alias truecolor="curl -s https://gist.githubusercontent.com/lifepillar/09a44b8cf0f9397465614e622979107f/raw/24-bit-color.sh | bash"
# Macのみの設定
if [[ "$(uname)" == "Darwin" ]]; then
  alias ls="ls -G"
  alias ll="ls -lG"
  alias l="ls -alG"
  alias beep="afplay /System/Library/Sounds/Submarine.aiff"
fi

# Linuxのみの設定
if [[ "$(uname)" == "Linux" ]]; then
  alias ls="ls --color=auto"
  alias ll="ls -l --color=auto"
  alias l="ls -al --color=auto"
  
  # xclip
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -o -selection clipboard"
fi
