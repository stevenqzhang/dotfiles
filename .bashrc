# fzf settings (mostly copied from @junegunn https://github.com/junegunn/dotfiles/blob/master/bashrc)
# -------------------------

#mac settings
unamestr=`uname`

#setup fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [[ "$unamestr" == 'Darwin' ]]; then
  # fd - cd to selected directory (I use fzf; original uses fzf-tmux)
  fd() {
    DIR=`find ${1:-*} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf` \
      && cd "${DIR}"
  }

  # fda - including hidden directories
  fda() {
    DIR=`find ${1:-.} -type d 2> /dev/null | fzf` && cd "${DIR}"
  }

  #inspired by fd, but uses mdfind on mac = faster 
  #braces are essential
  mdf() {
    DIR=$(mdfind "kind:folder" -name  2> /dev/null | fzf) && cd "${DIR}"
  }

  #no fuzzy option
  md() {
    DIR=$(mdfind "kind:folder" -name  2> /dev/null | fzf -e) && cd "${DIR}"
  }

  # opens files
  mof() {
    FILE=$(mdfind -name . 2> /dev/null | fzf) \
      && open "${FILE}"
  }

  #no fuzzy option
  mo() {
    FILE=$(mdfind -name . 2> /dev/null | fzf -e) \
      && open "${FILE}"
  }

  # copy file path to clipboard
  #newline must be stripped http://stackoverflow.com/questions/12524308/bash-strip-trailing-linebreak-from-output
  mpf() {
    FILE=$(mdfind -name . 2> /dev/null | fzf) \
      && echo "${FILE}" | tr -d '\n' | pbcopy
  }

  # copy file path to clipboard, no fuzzy
  mp() {
    FILE=$(mdfind -name . 2> /dev/null | fzf -e) \
      && echo "${FILE}" | tr -d '\n' | pbcopy
  }

  # searches contents of files too
  mfind() {
    FILE=$(mdfind . 2> /dev/null | fzf) \
      && open "$FILE"
  }
fi

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local file
  file=$(fzf-tmux --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

#nvm
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

#TODO git too show up in prompt too see junegunn

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
#
#i[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases
#[[ -s ~/.bashrc ]] && source ~/.bashrc
##git aliases
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gs='git status --untracked-files=no'
alias gd='git diff'
alias gk='gitk --all &'
alias gb='git branch'
alias ga='git add'
alias gau='git add -u'
alias gl="git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'--all"
alias gl2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"

alias please='sudo' #courtesy of https://twitter.com/starsandrobots/status/380857763733073920
#alias brew='sudo brew' #160118 i always forget sudo for brew

if [[ "$unamestr" == 'Darwin' ]]; then
  alias bci='brew cask install'
  # we use this instead of subl because of casks's directory structure
  # http://alittlecode.com/2013/10/open-a-file-in-sublime-text-via-os-x-terminal/
  alias sublime='open -a Sublime\ Text'
  alias e='sublime'
fi

#cd aliases
alias ..='cd ..'
alias ...='cd ...'
alias ....='cd ....'

# sd stands for switch dir
alias sd='cd -'
alias init='source ~/dev/dotfiles/.bashrc'
alias ls='ls -GFh'
alias grep='grep --color=always' 

# other
alias gw='./gradlew'

# for unblocking freedom
if [[ "$unamestr" == 'Darwin' ]]; then
  alias ps="echo use ps full path to kill freedom"
  alias kill="do you really need to kill freedom?"
fi

#windows and bash differ with open vs start, I always get confused
alias start='open'


#rm aliases to prevent accidental deletion http://apple.stackexchange.com/questions/17622/how-can-i-make-rm-move-files-to-the-trash-can
if [[ "$unamestr" == 'Darwin' ]]; then
  alias trash="rmtrash"
  alias del="rmtrash"
  alias rmt="rmtrash"
  alias rm="echo Use del, or the full path i.e. /bin/rm"
fi


#python aliases
alias nt='nosetests --with-timer'

if [[ "$unamestr" == 'Darwin' ]]; then
  #use ctrl keys to move forward and back in words (at least in OS X)
  bind '"\e[1;5D":backward-word'
  bind '"\e[1;5C":forward-word'
fi

#courtsey of http://stackoverflow.com/questions/2957684/awk-access-captured-group-from-line-pattern
function regex { gawk 'match($0,/'$1'/, ary) {print ary['${2:-'0'}']}'; }

# Rename command prompt
export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'
if [[ "$unamestr" == 'Darwin' ]]; then
  export PROMPT_COMMAND='echo -ne "\033]0;🍎${PWD##*/}\007"'
elif [[ "$unamestr" == 'Linux' ]]; then
  export PROMPT_COMMAND='echo -ne "\033]0;🐧${PWD##*/}\007"'
fi

# show git branch
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Set the PS1 prompt (with colors).
# Based on http://www-128.ibm.com/developerworks/linux/library/l-tip-prompt/
# And http://networking.ringofsaturn.com/Unix/Bash-prompts.php .
# http://ezprompt.net/
if [[ "$unamestr" == 'Darwin' ]]; then
  export PS1="\[\e[00;33m\]\u\[\e[0m\]\[\e[00;37m\]@\h:\[\e[0m\]\[\e[00;36m\]\w\[\e[0m\]\[\e[00;37m\] \[\e[0m\] \033[33m\]\$(parse_git_branch)\[\033[00m\] \D{%T} \n$ "
elif [[ "$unamestr" == 'Linux' ]]; then
  #extremely different colors for linux so I don't confuse myself when SSH'ing
  export PS1="\[\e[00;32m\] 🐧 \u\[\e[0m\]\[\e[00;45m\]@\h:\[\e[0m\]\[\e[00;36m\]\w\[\e[0m\]\[\e[00;37m\] \[\e[0m\] \033[33m\]\$(parse_git_branch)\[\033[00m\] \D{%T} \n$ "
fi

# Set the default editor to vim.
export EDITOR=vim
# 
# Avoid succesive duplicates in the bash command history.
export HISTCONTROL=ignoredups
# 
# Append commands to the bash command history file (~/.bash_history)
# instead of overwriting it.
shopt -s histappend #gives a invalid shell option name on mac.. dunno why..

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login

if [[ "$unamestr" == 'Darwin' ]]; then
  export HISTFILE=$HOME/Dropbox/dev/bash_eternal_history_mac.txt
elif [[ "$unamestr" == 'Linux' ]]; then
  export HISTFILE=$HOME/dev/bash_eternal_history_linux.txt
fi


# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss

PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

# Mac specifics
if [[ "$unamestr" == 'Darwin' ]]; then

# for homebrew installed nvm
export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"

# bashcompletion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
	      . $(brew --prefix)/etc/bash_completion
fi

fi

# git bash completion
source /usr/local/etc/bash_completion.d/git-completion.bash


# Path variable changes
# sublime as app
#set PATH $PATH=/usr/local/bin
export PATH=~/anaconda/bin:$PATH
export PATH=~/anaconda3/bin:$PATH

#for some reason this path needs to be added (similar bug: https://github.com/junegunn/fzf/issues/309)
# I probably havesome stuff above that overwrites the PATH variable...
# this is a hack for now
export PATH=~/.fzf/bin:$PATH

#add dev/scripts/bin to PATH
export PATH=~/Dropbox/dev/scripts/bin:$PATH

#Reminder for myself to annotate my bash history as an experiment if that can work for documentation
RED='\033[0;31m'
printf "${RED}REMINDER: annotate important commands in bash history\n"
printf "i.e. $ #this is a comment about this command; command\n"

