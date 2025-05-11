#!/bin/bash
# ~/.bashrc

export PATH=$PATH:$HOME/.cargo/bin:$HOME/.local/bin/:$HOME/.local/share/gem/ruby/3.0.0/bin:$HOME/Android/Sdk/platform-tools:$HOME/Android/Sdk/emulator:/etc/profile::$(go env GOBIN):$(go env GOPATH)/bin:$(gem env user_gemhome)/bin
export ANDROID_SDK=$HOME/Android/Sdk
export REACT_EDITOR=emacs
export GOPATH=/home/krug/prog/go
export NVM_DIR="$HOME/prog/js/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export BROWSER=/usr/bin/chromium
export HISTCONTROL=ignoreboth 
export WINEPREFIX=/home/krug/games/Games/wineprefix

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias la='colorls -A  | lolcat'
alias ll='colorls -l  | lolcat'
alias lal='colorls -la | lolcat'
alias ls='colorls --sd | lolcat'
alias sl='ls'
alias r='ranger | lolcat'
alias q='exit'
alias Q='exit'
alias p='sudo pacman -S'
alias cat='bat'
alias time='timedatectl status | lolcat'

#ranger like aliasses

#prog
alias gp='cd ~/prog/'
alias gpr='cd ~/prog/js/react/react-projects'
alias gpn='cd ~/prog/js/react/nextjs'
alias gprn='cd ~/prog/js/react/react-native'
alias gpj='cd ~/prog/js/node'
alias gpb='cd ~/prog/bash'
alias gpp='cd ~/prog/pas'
alias gpa='cd ~/prog/assembly'
alias gprb='cd ~/prog/ruby'
alias gpc='cd ~/prog/c'
alias gpcpp='cd ~/prog/cpp'
alias gps='cd ~/prog/svelte'
alias gpsk='cd ~/prog/svelekit'

#main dirs 
alias gd='cd ~/Downloads'
alias ge='cd /etc'
alias gu='cd /usr'
alias gg='cd ~/games'
alias ..='cd ../'

#colorls
source $(dirname $(gem which colorls))/tab_complete.sh

#changing the default prompt
#syntax: \[\e[#;#m\]
PS1="\[\e[2;31m\]\u \[\e[0;1;31m\] \W\[\e[0;32m\]  \[\e[0;]"
#starship prompt
# 

ALACRITTY_INSTANCES=0
for pid in $(pidof -x alacritty); do
	    ALACRITTY_INSTANCES=$((ALACRITTY_INSTANCES+1))
    done

if [ $ALACRITTY_INSTANCES -eq 1 ]; then
	neofetch | lolcat
fi

if [[ -f ~/.bash_prompt ]]; then
  . ~/.bash_prompt
fi

. "/home/krug/.deno/env"export PATH="/home/krug/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/krug/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
