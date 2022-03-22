function load() {
  if [ -f $1 ]; then
    . $1
  fi
}

DOT_FILES=(pathes.zsh env.zsh nix.zsh machine-specific.zsh common.zsh credentials.zsh functions.zsh aliases.zsh)

for file in ${DOT_FILES[@]}
do
  load $ZDOTDIR/$file
done
