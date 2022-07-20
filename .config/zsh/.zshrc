function load() {
  if [ -f $1 ]; then
    . $1
  fi
}

DOT_FILES=(machine-specific.zsh env.zsh pathes.zsh nix.zsh common.zsh functions.zsh aliases.zsh cargo.zsh npm-completion.zsh)

for file in ${DOT_FILES[@]}
do
  load $ZDOTDIR/$file
done

