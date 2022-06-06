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
      /opt/homebrew/bin/terminal-notifier -message "Command execution finished" -activate com.googlecode.iterm2
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

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init - )"; fi

# pyenv
if which pyenv > /dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# mcfly
eval "$(mcfly init zsh)"
