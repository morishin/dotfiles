function gdh() {
  git diff $@ | diff2html -s side -i stdin
}
compdef _git gdh=git-diff

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

# github
function github-url() {
	ruby <<-EOS
		require 'uri'
		def parse_remote(remote_origin)
		  if remote_origin =~ /^https:\/\//
		    uri = URI.parse(remote_origin)
		    [uri.host, uri.path]
		  elsif remote_origin =~ /^[^:\/]+:\/?[^:\/]+\/[^:\/]+$/
		    host, path = remote_origin.split(":")
		    [host.split("@").last, path]
		  else
		    raise "Not supported origin url: #{remote_origin}"
		  end
		end
		host, path = parse_remote(\`git config remote.origin.url\`.strip)
                puts "https://#{host}/#{path.gsub(/\.git$/, '')}"
	EOS
}

function preq() {
  # git rev-list --ancestry-path : only display commits that exist directly on the ancestry chain
  # git rev-list --first-parent  : follow only the first parent commit upon seeing a merge commit
  merge_commit=$(ruby -e 'print (File.readlines(ARGV[0]) & File.readlines(ARGV[1])).last' <(git rev-list --ancestry-path $1..master) <(git rev-list --first-parent $1..master))

  if git show $merge_commit | grep -q 'pull request'; then
    issue_number=$(git show $merge_commit | grep 'pull request' | ruby -ne 'puts $_.match(/#(\d+)/)[1]')
    url="$(github-url)/pull/${issue_number}"
  else
    url="$(github-url)/commit/${1}"
  fi

  open $url
}

function peco-select-git-checkout() {
    local selected_branch="$(git branch --sort=-committerdate | grep -v '^\*.*' | peco --query "$LBUFFER" | awk -F ' ' '{print $1}')"
    if [ -n $selected_branch ]; then
      BUFFER="git checkout $selected_branch"
      CURSOR=$#BUFFER
      zle accept-line
    fi
}
zle -N peco-select-git-checkout
bindkey "^gc" peco-select-git-checkout

function git-compare() {
  remote=$(git remote get-url $(git branch -r | grep $(git symbolic-ref --short HEAD) | sed -E "s/^\s*(.+)\/$(git symbolic-ref --short HEAD)/\1/") | sed -E "s/.+[\/:](.+)\/.+\.git/\1/")
  hub browse -- "compare/${1:-master}...$remote:$(git symbolic-ref --short HEAD)?expand=1"
}
