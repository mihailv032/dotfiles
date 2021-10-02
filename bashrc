#!/bin/bash
# ~/.bashrc

#adding new path to the $PATH
export PATH=$PATH:$HOME/.cargo/bin:$HOME/.bin/:$HOME/.local/share/gem/ruby/3.0.0/bin
export BROWSER=/usr/bin/chromium
export HISTCONTROL=ignoreboth 
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='colorls --sd'
alias r='ranger'
alias q='exit'
alias Q='exit'
alias la='ls -A'
alias p='sudo pacman -S'
alias cat='bat'
alias time='timedatectl status'
#ranger like aliasses

#prog
alias gpk='cd ~/prog/kirill'
alias gp='cd ~/prog/'
alias gpr='cd ~/prog/react'
alias gpj='cd ~/prog/js'
alias gpp='cd ~/prog/pas'
alias gpv='cd ~/prog/verstka'
alias gpb='cd ~/prog/bash'

#main dirs 
alias gd='cd ~/Downloads'
alias ge='cd /etc'
alias gu='cd /usr'
alias gg='cd /G'
alias ..='cd ../'

#colorls
source $(dirname $(gem which colorls))/tab_complete.sh

#changing the default prompt
#syntax: \[\e[#;#m\]
PS1="\[\e[2;31m\]\u \[\e[0;1;31m\]\W\[\e[0;32m\] \[\e[0;]"
#starship prompt
# 

ALACRITTY_INSTANCES=0
for pid in $(pidof -x alacritty); do
	    ALACRITTY_INSTANCES=$((ALACRITTY_INSTANCES+1))
    done

if [ $ALACRITTY_INSTANCES -eq 1 ]; then
	neofetch
fi


