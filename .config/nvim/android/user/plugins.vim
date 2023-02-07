" Install vim-plug if not found
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" vim-polyglot require
set nocompatible

call plug#begin()

   Plug 'one-dark/onedark.nvim'
   "Plug 'sheerun/vim-polyglot'
   Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
   Plug 'preservim/nerdtree'
   Plug 'neoclide/coc.nvim', {'branch': 'release'}
   Plug 'frazrepo/vim-rainbow'
   Plug 'itchyny/lightline.vim'

call plug#end()