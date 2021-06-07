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
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'junegunn/fzf'
Plug 'endel/vim-github-colorscheme'
Plug 'kshenoy/vim-signature'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-abolish'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'
Plug 'vimwiki/vimwiki'
Plug 'vito-c/jq.vim'
call plug#end()

filetype plugin indent on

" Persistent undo
set undofile
set undodir=~/.vim/undo
set undolevels=1000
set undoreload=10000

" Line wrapping and numbering
set nowrap number relativenumber

" Whitespace Management
set expandtab tabstop=4 paste

" Syntax Highlighting
filetype on
filetype plugin on
syntax enable

" Searching
set incsearch hlsearch smartcase
highlight Search cterm=NONE ctermbg=Yellow ctermfg=Black

" Setting toggle for word wrapping and line numbering. Useful for copying
" from vim buffer to clipboard.
noremap <F3> :set invrelativenumber invnumber invwrap<CR>

" Load visually selected text into / buffer.
vnoremap // y/<C-R>"<CR>

" Color column, but only if we exceed.
highlight ColorColumn ctermbg=darkred ctermfg=black
call matchadd('ColorColumn', '\%80v', 100)

colorscheme desert
set t_Co=256
if &diff
  colorscheme github
endif

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
autocmd FileType jq setlocal expandtab

" FZF configurations
nnoremap <silent> <C-p> :FZF<CR>

" LSP configurations
nnoremap gd :LspDefinition<CR>
nnoremap gr :LspReferences<CR>
nnoremap gi :LspHover<CR>

" Send async completion requests.
let g:lsp_async_completion = 1

" Enable UI for diagnostics
let g:lsp_signs_enabled = 1           " enable diagnostics signs in the gutter
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode

" Automatically show completion options
let g:asyncomplete_auto_popup = 1


" Google specific configurations.
if filereadable(expand("$HOME/.google.vimrc"))
    source ~/.google.vimrc
endif
