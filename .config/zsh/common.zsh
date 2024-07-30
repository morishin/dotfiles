autoload -Uz compaudit compinit && compinit -u
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

# autojump
if [ $(uname -s) = Darwin ]; then
  [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
else
  . /usr/share/autojump/autojump.sh
fi

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init - )"; fi

# mcfly
eval "$(mcfly init zsh)"

# direnv
eval "$(direnv hook zsh)"
