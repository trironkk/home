set nocompatible
filetype off

if empty(glob('~/.vim/autoload/plug.vim'))
  silent call system('mkdir -p ~/.vim/{autoload,bundle,cache,undo,backups,swaps}')
  silent call system('curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  execute 'source  ~/.vim/autoload/plug.vim'
  augroup plugsetup
    au!
    autocmd VimEnter * PlugInstall
  augroup end
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf.vim'
Plug 'kshenoy/vim-signature'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-abolish'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vimwiki/vimwiki'
call plug#end()

filetype plugin indent on

" Persistent undo
set undofile
set undodir=~/.vim/undo
set undolevels=1000
set undoreload=10000

" Line wrapping and numbering
set nowrap number

" Whitespace Management
set expandtab tabstop=4 paste

" Syntax Highlighting
filetype on
filetype plugin on
syntax enable

" Searching
set incsearch hlsearch smartcase
highlight Search guibg=grey guifg=white
highlight Search cterm=NONE ctermfg=white ctermbg=darkgrey

" Setting toggle for word wrapping and line numbering. Useful for copying
" from vim buffer to clipboard.
noremap <F3> :set invnumber invwrap<CR>

" Load visually selected text into / buffer.
vnoremap // y/<C-R>"<CR>

" Color column, but only if we exceed.
highlight ColorColumn ctermbg=darkred ctermfg=black
call matchadd('ColorColumn', '\%80v', 100)

" InsertLeave fires on esc (and not on CtrlC), so we map CtrlC to esc.
inoremap <C-C> <Esc>

" Highlight the active buffer's current line number.
highlight clear CursorLine
highlight CursorLineNR ctermbg=grey ctermfg=black
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" Configuring vimwiki
let g:vimwiki_list = [{'path': '~/local/vimwiki/',
                     \ 'syntax': 'default',
                     \ 'folding': '',
                     \ 'ext': '.md'},
                     \{'path': '~/local/vimwiki-personal/',
                     \ 'syntax': 'default',
                     \ 'folding': '',
                     \ 'ext': '.md'}]

" Open help in a vertical split.
autocmd FileType help wincmd L
