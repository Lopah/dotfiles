" Plain Vim fallback for machines without Neovim. It mirrors the options,
" mappings and autocommands of nvim/.config/nvim/init.lua without plugins;
" keep the two in step.
set nocompatible
set shell=bash
set tw=0
set clipboard=unnamedplus
set backspace=indent,eol,start
set guicursor=
filetype plugin indent on
let python_highlight_all=1

" Mappings
let mapleader = ","
map q <Nop>
map Q <Nop>
map ,c :lclose <Bar> pclose <Bar> cclose<CR>

set nu
set relativenumber
syntax on
set laststatus=2
set background=dark
colorscheme default
set encoding=utf-8
hi StatusLine ctermbg=none cterm=bold

au BufNewFile,BufRead *.md
    \ hi StatusLineNC ctermfg=white |
    \ setlocal nonu
au BufNewFile,BufRead *.py
    \ setlocal tabstop=4 |
    \ setlocal softtabstop=4 |
    \ setlocal shiftwidth=4 |
    \ setlocal textwidth=79 |
    \ setlocal expandtab |
    \ setlocal autoindent |
    \ setlocal fileformat=unix
au BufNewFile,BufRead *.js,*.html,*.css
    \ setlocal tabstop=2 |
    \ setlocal softtabstop=2 |
    \ setlocal shiftwidth=2
