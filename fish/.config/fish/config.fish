#! /bin/sh
set fish_greeting
export EDITOR=nvim || export EDITOR=vim
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
source $HOME/.config/fish/shortcuts.fish
source $HOME/.config/fish/colors.fish
set -gx PATH $HOME/.local/bin /usr/local/bin /opt/chromium /opt/android-sdk/platform-tools /opt/homebrew/bin $PATH

switch (uname)
case "*Darwin"
    alias lsblk="diskutil list"
case '*Linux'
    :
end

alias v=$EDITOR
alias la='ls -lha'
alias df='df -h'
alias du='du -ch'
alias ipp='dig -4 +short myip.opendns.com @resolver1.opendns.com'
alias yh='youtube-dl --continue --no-check-certificate --format=bestvideo+bestaudio[ext=m4a]/best --merge-output-format=mp4'
alias yd='youtube-dl --continue --no-check-certificate --format=bestvideo+bestaudio --exec="ffmpeg -i {} -c:v dnxhd -profile:v dnxhr_lb -vf fps=25/1,format=yuv422p -c:a pcm_s16le {}.mov && rm {}"'
alias ya='youtube-dl --continue --no-check-certificate --format=bestaudio -x --audio-format wav'

# Blog commands
alias generate='rm -f dst/.files && ssg5 src dst "Wolfgang\'s Blog" "http://notthebe.ee"'
alias deploy='rsync --rsync-path "sudo -u www-data rsync" -avP --delete dst/ snowfall:/var/www/blog'

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

