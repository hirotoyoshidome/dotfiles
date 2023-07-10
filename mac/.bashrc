# "-F":ディレクトリに"/"を表示 / "-G"でディレクトリを色表示
alias ls='ls -FG'
alias ll='ls -alFG'
alias lll='ls -alrt'

alias ..='cd ..'
alias ...='cd ../..'


# default:cyan / root:red
if [ $UID -eq 0 ]; then
    PS1="\[\033[31m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
else
    PS1="\[\033[36m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
fi


# mac
if [ -f $(/opt/homebrew/bin/brew --prefix)/etc/bash_completion ]; then
  source $(/opt/homebrew/bin/brew --prefix)/etc/bash_completion
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

