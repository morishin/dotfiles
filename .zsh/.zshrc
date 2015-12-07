function load() {
  if [ -f $1 ]; then
    . $1
  fi
}

DOT_FILES=(env.zsh credentials.zsh pathes.zsh common.zsh machine-specific.zsh functions.zsh aliases.zsh yo.zsh/yo.zsh)

for file in ${DOT_FILES[@]}
do
  load $ZDOTDIR/$file
done
