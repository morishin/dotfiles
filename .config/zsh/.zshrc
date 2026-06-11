function load() {
  if [ -f $1 ]; then
    . $1
  fi
}

DOT_FILES=(
  machine-specific.zsh
  env.zsh
  pathes.zsh
  nix.zsh
  common.zsh
  functions.zsh
  aliases.zsh
  cargo.zsh
  npm-completion.zsh
  deno.zsh
  bun.zsh
  asdf.zsh
  starship.zsh
  fzf.zsh
)

for file in ${DOT_FILES[@]}
do
  load $ZDOTDIR/$file
done

# bun completions
[ -s "/Users/morishin/.bun/_bun" ] && source "/Users/morishin/.bun/_bun"
