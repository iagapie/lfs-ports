# Setup for /bin/ls and /bin/grep to support color, the alias is in /etc/bashrc.
dc="/tools/bin/dircolors"

if [ -x "/usr/bin/dircolors" ]; then
    dc="/usr/bin/dircolors"
fi

if [ -f "/etc/dircolors" ] ; then
    eval $($dc -b /etc/dircolors)
fi

if [ -f "$HOME/.dircolors" ] ; then
    eval $($dc -b $HOME/.dircolors)
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
