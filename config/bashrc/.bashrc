#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fzf='find . -type f | grep -v ".local" | fzf'
PS1='[\u@\h \W]\$ '

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Run fastfetch on terminal startup
if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi



