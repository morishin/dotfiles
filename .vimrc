"--------------------
" NeoBundle settings
"--------------------
" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'sheerun/vim-polyglot'
NeoBundle 'thinca/vim-quickrun'

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

"--------------------
" Settings
"--------------------
" Color
syntax on
set background=dark
let g:solarized_termtrans=1
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
colorscheme solarized

" Edit
set number
set cursorline
set title
set showmatch
set whichwrap=b,s,h,l,<,>,[,],~
set wildmenu
set expandtab
set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4

" Search
set hlsearch
set incsearch
set smartcase
set wrapscan

" Include Other Settings
runtime! config/*.vim

