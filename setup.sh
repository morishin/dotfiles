#!/bin/zsh
setopt extended_glob

cd `dirname $0`

DOT_FILES=(.*~.git~.gitignore~.gitmodules com.googlecode.iterm2.plist)
for file in ${DOT_FILES[@]}
do
  ln -sni $(pwd)/$file $HOME/$(basename $file)
done

if [ ! -e $HOME/.vim/bundle/neobundle.vim ]; then
  git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
fi

unsetopt extended_glob
