function gi() {
  curl -L -s https://www.gitignore.io/api/$@
}

function chpwd() {
  tmux rename-window ${PWD##*/}
  ls -a
}

function pr() {
  if [ $# -eq 1 ]; then
    base=$1
  else
    base="develop"
  fi
  DEFAULT_IFS=$IFS
  IFS='/'
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' | read tag num
  IFS=$DEFAULT_IFS
  hub pull-request -i $num -b $base -h $tag/$num
  hub browse -- pull/$num
}

function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

function pskill() {
    ps aux | peco | awk '{print $2}' | xargs sudo kill -9
}

function adbss() {
    DATE=`date '+%y%m%d%H%M%S'`
    adb shell screencap -p /sdcard/${DATE}.png
    adb pull /sdcard/${DATE}.png ~/Desktop/
    adb shell rm /sdcard/${DATE}.png
}

function be () { bundle exec $* }
function _be () {
    if [[ -d vendor/bin ]]; then
        _arguments '*: :->'
        if [[ $CURRENT == 2 ]]; then
            _values "bundle exec" `\ls -1 vendor/bin`
        elif [[ $CURRENT == 3 && $line[1] == "rake" ]]; then
            _rake
        else
            _files
        fi
    fi
}

function airdrop() {
    if [ $# -ne 1 ]; then
      echo "usage: $0 FILE" 1>&2
      exit 1
    fi

    if [ ! -e $1 ]; then
      echo "$1: No such file or directory" 1>&2
      exit 1
    fi

    target=file://$(cd $(dirname $1) && pwd)/$(basename $1)
    terminal-share -service airdrop -url $target
}

function peco-select-gitadd() {
    local SELECTED_FILE_TO_ADD="$(git status --porcelain | \
                                  peco --query "$LBUFFER" | \
                                  awk -F ' ' '{print $NF}')"
    if [ -n "$SELECTED_FILE_TO_ADD" ]; then
      BUFFER="git add $(echo "$SELECTED_FILE_TO_ADD" | tr '\n' ' ')"
      CURSOR=$#BUFFER
    fi
    zle accept-line
    # zle clear-screen
}
zle -N peco-select-gitadd
bindkey "^g^a" peco-select-gitadd

genymotion_peco(){
  if [ -z "$GENYMOTION_APP_HOME" ]; then
    echo "GENYMOTION_APP_HOME is empty. Use '/Applications/Genymotion.app/' instead this time."
    player="/Applications/Genymotion.app/Contents/MacOS/player"
  else
    player="$GENYMOTION_APP_HOME/Contents/MacOS/player"
  fi

  vm_name=`VBoxManage list vms | peco`
  if [[ $vm_name =~ ^\"(.+)\".* ]] ; then
     name=${match[1]}
     echo "boot $name"
     $player --vm-name "$name" &
  fi
}

function mspec() {
  find **/spec -name "*$1*_spec.rb" | xargs bundle exec rspec
}
