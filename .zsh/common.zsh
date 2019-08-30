autoload -U compaudit compinit
autoload -Uz url-quote-magic; zle -N self-insert url-quote-magic
autoload -U colors; colors

setopt complete_aliases
setopt nobeep
setopt nolistbeep
setopt no_flow_control
setopt print_eight_bit
setopt auto_menu
setopt auto_list
setopt magic_equal_subst
setopt auto_param_slash
setopt list_packed
setopt list_types
setopt noautoremoveslash
setopt correct
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt hist_ignore_dups
setopt hist_save_nodups
setopt hist_reduce_blanks
setopt hist_no_store
setopt hist_ignore_space
setopt extended_history
setopt share_history
setopt append_history
setopt inc_append_history
setopt hist_verify
setopt no_hup
setopt no_checkjobs
setopt notify

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey -e

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.zcache"
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

zmodload zsh/datetime

function preexec () {
   _prev_cmd_start_time=$EPOCHREALTIME
   _cmd_is_running=true
}

function precmd() {
  setprompt

  if [ -z "$_prev_cmd_start_time" ] ; then
    return
  fi
  if $_cmd_is_running; then
    _prev_cmd_exec_time=$((EPOCHREALTIME - _prev_cmd_start_time))
    if ((_prev_cmd_exec_time > 1)); then
      printf "\e[94m-- %.2fs --\n" $_prev_cmd_exec_time
    fi
    if ((_prev_cmd_exec_time > 5)); then
      terminal-notifier -message "Command execution finished" -activate com.googlecode.iterm2
    fi
  fi
  _cmd_is_running=false
}

function setprompt() {
  PROMPT="%{${fg[green]}%}%n%{${fg[yellow]}%} %~%{${reset_color}%}"
  st=`git status 2>/dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    color=${fg[cyan]}
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    color=${fg[blue]}
  elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
    color=${fg_bold[red]}
  else
    color=${fg[red]}
  fi
  PROMPT+=" %{$color%}$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /')%b%{${reset_color}%}"

  if [ -n "$VIRTUAL_ENV" ]; then
    PROMPT="(`basename \"$VIRTUAL_ENV\"`)$PROMPT"
  fi
}
PROMPT2="%_%% "
SPROMPT="%r is correct? [No,Yes,Abort,Exit]: "

# autojump
if [ $(uname -s) = Darwin ]; then
  [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
else
  . /usr/share/autojump/autojump.sh
fi

# tmux
# which tmux 2>&1 >/dev/null && [ -z $TMUX ] && (tmux -2 attach || tmux -2 new-session)
# tmux rename-window ${PWD##*/}

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init - )"; fi

# pyenv
if which pyenv > /dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# git-hooks
function replace-githooks() {
  if [ -e .git/hooks ]; then
    rm -rf .git/hooks
    ln -s ~/.git-template/hooks .git/hooks
  fi
}

# docker toolbox
# eval "$(docker-machine env default)"

# bugfix compdef
# https://github.com/robbyrussell/oh-my-zsh/blob/4589bc6c654650d52a47b5cb86c588f4ab2aca46/lib/compfix.zsh
# Handle completions insecurities (i.e., completion-dependent directories with
# insecure ownership or permissions) by:
#
# * Human-readably notifying the user of these insecurities.
# * Moving away all existing completion caches to a temporary directory. Since
#   any of these caches may have been generated from insecure directories, they
#   are all suspect now. Failing to do so typically causes subsequent compinit()
#   calls to fail with "command not found: compdef" errors. (That's bad.)
function handle_completion_insecurities() {
  # List of the absolute paths of all unique insecure directories, split on
  # newline from compaudit()'s output resembling:
  #
  #     There are insecure directories:
  #     /usr/share/zsh/site-functions
  #     /usr/share/zsh/5.0.6/functions
  #     /usr/share/zsh
  #     /usr/share/zsh/5.0.6
  #
  # Since the ignorable first line is printed to stderr and thus not captured,
  # stderr is squelched to prevent this output from leaking to the user.
  local -aU insecure_dirs
  insecure_dirs=( ${(f@):-"$(compaudit 2>/dev/null)"} )

  # If no such directories exist, get us out of here.
  if (( ! ${#insecure_dirs} )); then
      print "[oh-my-zsh] No insecure completion-dependent directories detected."
      return
  fi

  # List ownership and permissions of all insecure directories.
  print "[oh-my-zsh] Insecure completion-dependent directories detected:"
  ls -ld "${(@)insecure_dirs}"
  print "[oh-my-zsh] For safety, completions will be disabled until you manually fix all"
  print "[oh-my-zsh] insecure directory permissions and ownership and restart oh-my-zsh."
  print "[oh-my-zsh] See the above list for directories with group or other writability.\n"

  # Locally enable the "NULL_GLOB" option, thus removing unmatched filename
  # globs from argument lists *AND* printing no warning when doing so. Failing
  # to do so prints an unreadable warning if no completion caches exist below.
  setopt local_options null_glob

  # List of the absolute paths of all unique existing completion caches.
  local -aU zcompdump_files
  zcompdump_files=( "${ZSH_COMPDUMP}"(.) "${ZDOTDIR:-${HOME}}"/.zcompdump* )

  # Move such caches to a temporary directory.
  if (( ${#zcompdump_files} )); then
    # Absolute path of the directory to which such files will be moved.
    local ZSH_ZCOMPDUMP_BAD_DIR="${ZSH_CACHE_DIR}/zcompdump-bad"

    # List such files first.
    print "[oh-my-zsh] Insecure completion caches also detected:"
    ls -l "${(@)zcompdump_files}"

    # For safety, move rather than permanently remove such files.
    print "[oh-my-zsh] Moving to \"${ZSH_ZCOMPDUMP_BAD_DIR}/\"...\n"
    mkdir -p "${ZSH_ZCOMPDUMP_BAD_DIR}"
    mv "${(@)zcompdump_files}" "${ZSH_ZCOMPDUMP_BAD_DIR}/"
  fi
}

# https://github.com/robbyrussell/oh-my-zsh/blob/4589bc6c654650d52a47b5cb86c588f4ab2aca46/oh-my-zsh.sh#L62-L78
# Save the location of the current completion dump file.
if [ -z "$ZSH_COMPDUMP" ]; then
  ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
fi

if [[ $ZSH_DISABLE_COMPFIX != true ]]; then
  # If completion insecurities exist, warn the user without enabling completions.
  if ! compaudit &>/dev/null; then
    # This function resides in the "lib/compfix.zsh" script sourced above.
    handle_completion_insecurities
  # Else, enable and cache completions to the desired file.
  else
    compinit -d "${ZSH_COMPDUMP}"
  fi
else
  compinit -i -d "${ZSH_COMPDUMP}"
fi
