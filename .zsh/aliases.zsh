# utility
alias ls='exa'
alias ll='exa -l'
alias la='exa -A'
alias lla='exa -lA'
alias cp='cp -i'
alias mv='mv -i'
alias du='du -h'
# mysql
alias mysql='mysql --pager="less -SiFX"'
alias psql='PAGER="less -SiFX" psql'
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
alias ggrep='git grep'
alias gst='git stash'
alias gsp='git stash pop'
alias gcp='git cherry-pick'
compdef _git gcp=git-cherry-pick
alias __git-cherry_pick_main=_git_cherry_pick
alias gb='git branch'
compdef _git gb=git-branch
alias __git-branch_main=_git_branch
alias remove-gomi="git status --short | perl -pe 's/^.+ //' | xargs perl -pi -e 's/^\s*(binding\.pry|console\.log).*\n//'"
# haskell
alias ghc='stack ghc'
alias ghci='stack ghci'
alias runghc='stack runghc'
alias runhaskell='stack runghc'
# imagemagick
alias convert='docker run -v $PWD:/mount -w /mount v4tech/imagemagick convert'
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
alias json="jq '.' -C | less -R"
function v() {
  setopt +o nomatch # suppress zsh message
  if [ -z $1 ]; then
    DIR="."
  else
    DIR=$1
  fi
  WORKSPACE=`find $DIR -maxdepth 1 -name *.code-workspace 2>/dev/null`
  if [ $? -eq 0 ] && [ -n "$WORKSPACE" ]; then
    DIR=$WORKSPACE
  fi
  open -a "Visual Studio Code" $DIR
  setopt -o nomatch
}
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
