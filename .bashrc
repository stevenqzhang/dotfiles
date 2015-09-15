# fzf settings (mostly copied from @junegunn https://github.com/junegunn/dotfiles/blob/master/bashrc)
# -------------------------


#setup fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

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

# searches contents of files too
mfind() {
  FILE=$(mdfind . 2> /dev/null | fzf) \
    && open "$FILE"
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local file
  file=$(fzf-tmux --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

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
alias gk='gitk --all &'
alias gb='git branch'
alias ga='git add -u'
alias please='sudo' #courtesy of https://twitter.com/starsandrobots/status/380857763733073920

#
#cd aliases
alias ..='cd ..'
#
alias init='source ~/dev/dotfiles/.bashrc'
alias ls='ls -GFh'

alias grep='grep --color=always'

#windows and bash differ with open vs start, I always get confused
alias start='open'

#
# Set the PS1 prompt (with colors).
# Based on http://www-128.ibm.com/developerworks/linux/library/l-tip-prompt/
# And http://networking.ringofsaturn.com/Unix/Bash-prompts.php .
#PS1="\[\e[36;1m\]\h:\[\e[32;1m\]\w$ \[\e[0m\]" #disabled b/c doesn't work on windows
export PS1="\[\e[00;33m\]\u\[\e[0m\]\[\e[00;37m\]@\h:\[\e[0m\]\[\e[00;36m\]\w\[\e[0m\]\[\e[00;37m\] \[\e[0m\] \D{%T} \n$ "
# 
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
export HISTFILE=$HOME/dev/bash_eternal_history/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss

PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

unamestr=uname

# Mac specifics
if [[ "$unamestr" == 'Darwin' ]]; then

# bashcompletion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
	      . $(brew --prefix)/etc/bash_completion
fi



# sublime as app
#set PATH $PATH=/usr/local/bin

fi

#for some reason this path needs to be added (similar bug: https://github.com/junegunn/fzf/issues/309)
# I probably havesome stuff above that overwrites the PATH variable...
# this is a hack for now
export PATH=~/.fzf/bin:$PATH
