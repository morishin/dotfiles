#!/bin/zsh
setopt extended_glob

cd `dirname $0`

echo
echo "👉 Linking dotfiles..."

DOT_FILES=(.*~.git~.gitignore~.gitmodules~.DS_Store~.config)
for file in ${DOT_FILES[@]}
do
  ln -sni $(pwd)/$file $HOME/$(basename $file)
done

DOT_FILES_NOT_OVERWRITE_DIRECTORY=(.config)
for file in ${DOT_FILES_NOT_OVERWRITE_DIRECTORY[@]}
do
  ln -si $(pwd)/$file/* $HOME/$file
done

ln -si $(pwd)/bin/* $HOME/.local/bin/

unsetopt extended_glob
