#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fzf='find . -type f | grep -v ".local" | fzf'
PS1='[\u@\h \W]\$ '

if [ -f /usr/bin/fastfetch ]; then
    fastfetch
fi

