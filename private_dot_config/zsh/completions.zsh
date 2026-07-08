# CLI completions generated on demand and cached (delete a cached file to regenerate)
COMPLETIONS_CACHE=$ZDOTDIR/.completions
mkdir -p $COMPLETIONS_CACHE
(( $+commands[deno] )) && [[ ! -f $COMPLETIONS_CACHE/deno.zsh ]] && deno completions zsh > $COMPLETIONS_CACHE/deno.zsh
(( $+commands[npm] )) && [[ ! -f $COMPLETIONS_CACHE/npm.zsh ]] && npm completion > $COMPLETIONS_CACHE/npm.zsh
for f in $COMPLETIONS_CACHE/*.zsh(N); do
  source $f
done
