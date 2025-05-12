if status is-interactive
    # Commands to run in interactive sessions can go here
end



set alacrittyInstances 0
for pid in $(pidof -x alacritty) #doesnt work
    set alacrittyInstances (math $alacrittyInstances + 1)
end    

if [ $alacrittyInstances < 1 ]
   neofetch | lolcat
end

set fish_greeting 

alias sl='ls'
alias la='colorls -A  | lolcat'
alias ll='colorls -l  | lolcat'
alias lal='colorls -la | lolcat'
#alias ls='colorls --sd | lolcat'
alias r='ranger | lolcat'
alias q='exit'
alias Q='exit'
alias p='sudo pacman -S'
alias update='sudo  pacman -Syyu && yay -S xmonad-git xmonad-contrib-git && xmonad --recompile'
alias cat='bat'
#alias time='timedatectl status | lolcat'

#prog
alias gp='cd ~/prog/'
alias gpr='cd ~/prog/js/react/react-projects'
alias gpn='cd ~/prog/js/react/nextjs'
alias gpe='cd ~/prog/js/electron'
alias gprn='cd ~/prog/js/react/react-native'
alias gpj='cd ~/prog/js/node'
alias gpp='cd ~/prog/php'
alias gpg='cd ~/prog/go'
alias gpb='cd ~/prog/bash'
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


#sashimi prompt
function fish_prompt 

  set -g purple (set_color -o "#D700D7")
  set -g blue (set_color -o "#875FFF")
  set -g green (set_color -o "#1ea11b")
  set -g red (set_color -o "#BC1142")
  set -g normal (set_color normal)
  set -g otherBlue (set_color -o "#5F5FFF")
  set -l ahead (_git_ahead)
  set -g whitespace ' '
  set -l purple2 (set_color -o "#AF00D7")
  set -l purple3 (set_color -o "#AF00FF")
  set -l purple4 (set_color -o "#8700FF")
  set -l kindaBlue (set_color -o "#875FFF")
  set -l blue2 (set_color -o "#5F87FF")

  set initial_indicator "$purple$purple2 k$purple3 r$purple4 u$kindaBlue g$blue "

  set -l cwd $otherBlue(basename (prompt_pwd))" $red$green "

  if [ (_git_branch_name) ]
    if test (_git_branch_name) = 'master'
	  set cwd $otherBlue(basename (prompt_pwd))
      set -l git_branch (_git_branch_name)
      set git_info "$normal   $red$git_branch $green "
    else
      set cwd $otherBlue(basename (prompt_pwd))
	  set -l dirty "$yellow $red$green "
      set -l git_branch (_git_branch_name)
      set git_info "$normal  $blue$git_branch$normal"
    end

    if [ (_is_git_dirty) ]
	  set cwd $otherBlue(basename (prompt_pwd))
      set -l dirty "$yellow $red$green "
      set git_info "$git_info$dirty"
    end
  else 
  end

  # Notify if a command took more than 5 minutes
  if [ "$CMD_DURATION" -gt 300000 ]
    echo The last command took (math "$CMD_DURATION/1000") seconds.
  end

  echo -n -s $initial_indicator $whitespace$cwd $git_info $whitespace $ahead $status_indicator
end

function _git_ahead
  set -l commits (command git rev-list --left-right '@{upstream}...HEAD' 2>/dev/null)
  if [ $status != 0 ]
    return
  end
  set -l behind (count (for arg in $commits; echo $arg; end | grep '^<'))
  set -l ahead  (count (for arg in $commits; echo $arg; end | grep -v '^<'))
  switch "$ahead $behind"
    case ''     # no upstream
    case '0 0'  # equal to upstream
      return
    case '* 0'  # ahead of upstream
      echo "$blue↑$normal_c$ahead$whitespace"
    case '0 *'  # behind upstream
      echo "$red↓$normal_c$behind$whitespace"
    case '*'    # diverged from upstream
      echo "$blue↑$normal$ahead $red↓$normal_c$behind$whitespace"
  end
end

function _git_branch_name
  echo (command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2>/dev/null)
end

