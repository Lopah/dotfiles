# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME is set per operating system above `source $ZSH/oh-my-zsh.sh`.

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# macOS keeps Oh My Zsh's stock setup. The other machines keep the older
# preferences; agnoster needs the Powerline fonts, which the installer adds
# only outside macOS.
if [[ $OSTYPE == darwin* ]]; then
  ZSH_THEME="robbyrussell"
  plugins=(git)
else
  ZSH_THEME="agnoster"
  COMPLETION_WAITING_DOTS="true"
  DISABLE_UNTRACKED_FILES_DIRTY="true"
  HIST_STAMPS="dd.mm.yyyy"
  plugins=(git docker docker-compose mvn svn vagrant)
fi

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pipx installs its commands here.
export PATH="$PATH:$HOME/.local/bin"

# pnpm's default home differs between macOS and Linux.
if [[ $OSTYPE == darwin* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) [ -d "$PNPM_HOME/bin" ] && export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# LM Studio CLI (lms)
[ -d "$HOME/.lmstudio/bin" ] && export PATH="$PATH:$HOME/.lmstudio/bin"

alias tpr="git pr"  # defined in .gitconfig so it also works outside zsh

# macOS provides its own ssh-agent and lacks GNU ls, dircolors and
# notify-send, so these settings serve only the Linux and Windows machines.
if [[ $OSTYPE != darwin* ]]; then
  export EDITOR='vim'

  export SSH_KEY_PATH="$HOME/.ssh/rsa_id"

  # The agent's environment is saved to a file so every shell reuses one
  # agent instead of starting a new one and asking for the passphrase again.
  env=~/.ssh/agent.env

  agent_load_env() { test -f "$env" && . "$env" >|/dev/null; }

  agent_start() {
    (
      umask 077
      ssh-agent >|"$env"
    )
    . "$env" >|/dev/null
  }

  agent_load_env

  # agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
  agent_run_state=$(
    ssh-add -l >|/dev/null 2>&1
    echo $?
  )

  if { [ ! "$SSH_AUTH_SOCK" ] || [ "$agent_run_state" = 2 ]; } && [ -f "$SSH_KEY_PATH" ]; then
    agent_start
    ssh-add "$SSH_KEY_PATH"
  elif [ "$SSH_AUTH_SOCK" ] && [ "$agent_run_state" = 1 ] && [ -f "$SSH_KEY_PATH" ]; then
    ssh-add "$SSH_KEY_PATH"
  fi

  unset env

  # Add an "alert" alias for long running commands.  Use like so:
  #   sleep 10; alert
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

  # enable color support of ls and also add handy aliases
  if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
  fi

  case "$OSTYPE" in cygwin* | msys*)
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
      alias htop='ntop'
      ;;
  esac

  alias cll='clear; ls -lah'
  alias countFiles='ls -1 | wc -l'
  alias ll='ls -lah'
  alias ls='ls -F --color=auto --show-control-chars'
  alias la="ls -A"
  alias l="ls -CF"
  alias vi="vim"
  alias rider="Rider.cmd"
  alias riderEA="RiderEA.cmd"
  alias webstorm="webstorm.cmd"
  alias pn="pnpm"
  alias gitclean="git branch --merged | grep -v '\*\|master\|main\|develop' | xargs -n 1 git branch -d"

  export PROMPT_EOL_MARK=""
fi
