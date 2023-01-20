~/.bashrc/.bash_profile

alias ls='ls -F --color=auto --show-control-chars'
alias ll='ls -l'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  #alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias rider="Rider.cmd"
alias riderEA="RiderEA.cmd"
alias pn="pnpm"

alias ls="ls -F --color=auto --show-control-chars"
alias ll="ls -lah"
alias la="ls -A"
alias l="ls -CF"

case "$TERM" in
xterm*)
  # The following programs are known to require a Win32 Console
  # for interactive usage, therefore let's launch them through winpty
  # when run inside `mintty`.
  for name in node ipython php php5 psql python2.7; do
    case "$(type -p "$name".exe 2>/dev/null)" in
    '' | /usr/bin/*) continue ;;
    esac
    alias $name="winpty $name.exe"
  done
  ;;
esac
