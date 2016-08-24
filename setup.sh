#!/bin/zsh
setopt extended_glob

cd `dirname $0`

DOT_FILES=(.*~.git~.gitignore~.gitmodules~.DS_Store com.googlecode.iterm2.plist)
for file in ${DOT_FILES[@]}
do
  ln -sni $(pwd)/$file $HOME/$(basename $file)
done

echo "sudo permission is necessary to symlink IDETextKeyBindingSet.plist"
sudo ln -sni $(pwd)/IDETextKeyBindingSet.plist $(xcode-select -print-path)/../Frameworks/IDEKit.framework/Versions/A/Resources/

if [ ! -e $HOME/.vim/bundle/neobundle.vim ]; then
  git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
fi

unsetopt extended_glob
