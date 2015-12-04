# utility
alias ls='ls -hF -G'
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lA'
alias cp='cp -i'
alias mv='mv -i'
alias du='du -h'
# mysql
alias mysql='mysql --pager="less -SiFX"'
# python
alias py='python'
alias py2='python2'
alias py3='python3'
alias activate='source `find . -regex ".*/bin/activate"`'
# git
alias g='git'
compdef _git g=git
alias gg='git graph'
alias ga='git add .'
alias gcm='git commit'
alias gd='git diff'
compdef _git gd=git-diff
alias __git-diff_main=_git_diff
alias gco='git checkout'
compdef _git gco=git-checkout
alias __git-checkout_main=_git_checkout
alias gs='git status'
alias gpl='git pull'
alias gps='git push'
# os specific
case "${OSTYPE}" in
darwin*)
  alias size='du -h -d 1'
  alias op='open .'
  alias chrome='open -a Google\ Chrome'
  alias installapp='find ./ -name "*.apk" | peco | xargs adb install -r'
  alias uninstallapp='adbp shell pm list package | sed -e s/package:// | peco | xargs adbp uninstall'
  ;;
linux*)
  alias size='du -h --max-depth 1'
  ;;
esac
