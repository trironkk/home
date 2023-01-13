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
Plug 'bazelbuild/vim-bazel'
Plug 'endel/vim-github-colorscheme'
Plug 'google/vim-maktaba'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kshenoy/vim-signature'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'preservim/nerdtree'
Plug 'mattn/vim-lsp-settings'
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

" Color scheme
colorscheme github
set t_Co=256

" Popup Menu
highlight Pmenu ctermbg=darkgrey guibg=darkgrey

" Highlight the active buffer's current line number.
highlight clear CursorLine
highlight CursorLineNR ctermbg=grey ctermfg=black

autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" Configuring vimwiki
let g:vimwiki_list = [{'path': '~/local/vimwiki/',
                     \ 'syntax': 'default',
                     \ 'folding': '',
                     \ 'ext': '.vimwiki'},
                     \{'path': '~/local/vimwiki-personal/',
                     \ 'syntax': 'default',
                     \ 'folding': '',
                     \ 'ext': '.vimwiki'}]

" Open help in a vertical split.
autocmd FileType help wincmd L
autocmd FileType jq setlocal expandtab

" FZF configurations
nnoremap <silent> <C-p> :FZF<CR>

" LSP configurations
autocmd FileType java setlocal omnifunc=lsp#complete
autocmd FileType javascript setlocal omnifunc=lsp#complete
autocmd FileType python setlocal omnifunc=lsp#complete
autocmd FileType textproto setlocal omnifunc=lsp#complete

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd :LspDefinition<CR>
    nmap <buffer> gr :LspReferences<CR>
    nmap <buffer> gi :LspImplementation<CR>
    nmap <buffer> gt :LspTypeDefinition<CR>

    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> <leader>d :LspDocumentDiagnostics<CR>
    nmap <buffer> <leader>q :LspCodeAction<CR>

    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> [e <plug>(lsp-previous-error)
    nmap <buffer> ]e <plug>(lsp-next-error)

    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 1000

    let g:lsp_diagnostics_echo_cursor = 1
    let g:lsp_document_highlight_enabled = 1
    let g:lsp_highlights_enabled = 1
    " let g:lsp_log_file = expand('~/vim-lsp.log')
    let g:lsp_semantic_enabled = 1
    let g:lsp_signs_enabled = 1

    let g:lsp_preview_float = 1
    let g:lsp_show_workspace_edits = 1

    " let g:asyncomplete_auto_popup = 1
    " let g:asyncomplete_auto_completeopt = 0
    " set completeopt=menuone,noinsert,preview

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.java call execute('LspDocumentFormatSync')
    autocmd! BufWritePre *.py call execute('LspDocumentFormatSync')

    " initialize Python lsp
    if executable('pylsp')
        " pip install python-lsp-server
        au User lsp_setup call lsp#register_server({
            \ 'name': 'pylsp',
            \ 'cmd': {server_info->['pylsp']},
            \ 'allowlist': ['python'],
            \ })
    endif
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" TMUX specific adjustments
" See :help tmux-integration
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
    " Better mouse support, see  :help 'ttymouse'
    set ttymouse=sgr

    " Enable bracketed paste mode, see  :help xterm-bracketed-paste
    let &t_BE = "\<Esc>[?2004h"
    let &t_BD = "\<Esc>[?2004l"
    let &t_PS = "\<Esc>[200~"
    let &t_PE = "\<Esc>[201~"

    " Enable focus event tracking, see  :help xterm-focus-event
    let &t_fe = "\<Esc>[?1004h"
    let &t_fd = "\<Esc>[?1004l"
    execute "set <FocusGained>=\<Esc>[I"
    execute "set <FocusLost>=\<Esc>[O"

    " Enable modified arrow keys, see  :help arrow_modifiers
    execute "silent! set <xUp>=\<Esc>[@;*A"
    execute "silent! set <xDown>=\<Esc>[@;*B"
    execute "silent! set <xRight>=\<Esc>[@;*C"
    execute "silent! set <xLeft>=\<Esc>[@;*D"
endif

" Google specific configurations.
if filereadable(expand("~/.google.vimrc"))
    source ~/.google.vimrc
endif

