autoload -Uz compinit
compinit

function gdh() {
  git diff $@ | diff2html -s side -i stdin
}
compdef _git gdh=git-diff

function gi() {
  curl -L -s https://www.gitignore.io/api/$@
}

# function peco-select-history() {
#     local tac
#     if which tac > /dev/null; then
#         tac="tac"
#     else
#         tac="tail -r"
#     fi
#     BUFFER=$(history -n 1 | \
#         eval $tac | \
#         peco --query "$LBUFFER")
#     CURSOR=$#BUFFER
#     zle clear-screen
# }
# zle -N peco-select-history
# bindkey '^r' peco-select-history

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
    local SELECTED_FILE_TO_ADD="$(git status -s | cut -c4- | \
                                  peco --query "$LBUFFER" | \
                                  awk -F ' ' '{ printf "\"%s\" ", $NF }')"
    if [ -n "$SELECTED_FILE_TO_ADD" ]; then
      BUFFER="git add $(echo "$SELECTED_FILE_TO_ADD" | tr '\n' ' ')"
      CURSOR=$#BUFFER
    fi
    zle accept-line
    # zle clear-screen
}
zle -N peco-select-gitadd
bindkey "^ga" peco-select-gitadd

function peco-select-gitreset() {
    local SELECTED_FILE_TO_RESET="$(git diff --staged --name-only --relative | \
                                  peco --query "$LBUFFER" | \
                                  awk -F ' ' '{ printf "\"%s\" ", $NF }')"
    if [ -n "$SELECTED_FILE_TO_RESET" ]; then
      BUFFER="git reset $(echo "$SELECTED_FILE_TO_RESET" | tr '\n' ' ')"
      CURSOR=$#BUFFER
    fi
    zle accept-line
    # zle clear-screen
}
zle -N peco-select-gitreset
bindkey "^gr" peco-select-gitreset

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

function gpl() {
  if [ -z "$1" ]; then
    remote=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} | sed -E "s/(.+)\/.+/\1/")
    if [ -n "$remote" ]; then
      git pull $remote $(git rev-parse --abbrev-ref HEAD)
    fi
  else
    git pull $1 $(git rev-parse --abbrev-ref HEAD)
  fi
}

# git-hooks
function replace-githooks() {
  rm -rf .git/hooks
  ln -s $GIT_TEMPLATE_DIR/hooks .git/hooks
}

function gcl() { git clone $1 $2 && cd $(basename $_ .git) && replace-githooks }

function killp() {
  kill -9 $(lsof -t -i:$1)
}
