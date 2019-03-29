#!/bin/zsh
setopt extended_glob

cd `dirname $0`

DOT_FILES=(.*~.git~.gitignore~.gitmodules~.DS_Store~.config com.googlecode.iterm2.plist)
for file in ${DOT_FILES[@]}
do
  ln -sni $(pwd)/$file $HOME/$(basename $file)
done

DOT_FILES_NOT_OVERWRITE_DIRECTORY=(.config)
for file in ${DOT_FILES_NOT_OVERWRITE_DIRECTORY[@]}
do
  ln -si $(pwd)/$file/* $HOME/$file
done

if [ ! -e $HOME/.vim/bundle/neobundle.vim ]; then
  git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
fi

unsetopt extended_glob
