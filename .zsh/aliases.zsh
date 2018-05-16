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
alias psql='PAGER="less -SiFX" psql'
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
compdef _git gpl=git-pull
alias __git-pull_main=_git_pull
alias gps='git push'
compdef _git gps=git-push
alias __git-push_main=_git_push
alias gcl='git clone'
alias ggrep='git grep'
alias gst='git stash'
alias gsp='git stash pop'
alias gcp='git cherry-pick'
compdef _git gcp=git-cherry-pick
alias __git-cherry_pick_main=_git_cherry_pick
alias gb='git branch'
compdef _git gb=git-branch
alias __git-branch_main=_git_branch
# haskell
alias ghc='stack ghc'
alias ghci='stack ghci'
alias runghc='stack runghc'
alias runhaskell='stack runghc'
# extract
function _extract() {
  case $1 in
    *tar.bz|*.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar xJvf $1;;
    *.tar.Z|*.taz) tar xzvf $1;;
    *.arj) unarj $1;;
    *.bz2) bzip2 -dc $1;;
    *.gz) gzip -dc $1;;
    *.lzh) lha e $1;;
    *.rar) unrar x $1;;
    *.tar) tar xvf $1;;
    *.xz) xz -dv $1;;
    *.Z) uncompress $1;;
    *.zip) unzip $1;;
    *.7z) 7z x $1 -oextracted;;
  esac
}
alias -s {arz,bz2,gz,lzh,rar,tar,tbz,tgz,xz,Z,zip,7z}=_extract
# others
alias amesh='curl -L 'https://ame.cnosuke.com/current' 2> /dev/null | imgcat'
alias podi='bundle exec pod install; terminal-notifier -message "Done \`pod install\`"'
alias json="jq '.' -C | less -R"
alias vscode='open -a "Visual Studio Code"'
alias simu="xcrun simctl boot \`xcrun simctl list devices | peco | sed -E 's/^.* \(([A-Z0-9\-]*)\) .*$/\1/1'\`"
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
