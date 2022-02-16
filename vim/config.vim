filetype plugin on

" Install vim-plug if not installed.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-sensible'

set wrap
set clipboard=unnamed
"
" reload file if edited outside vim
set autoread

let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=1\x7"

let mapleader=","

set encoding=UTF-8

nnoremap <Leader>r :source $MYVIMRC<CR>

" CTRL+P
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_cmd = 'CtrlPMRU'

" indentation
set tabstop=4
set autoindent
set smartindent
set shiftround
set shiftwidth=4
set smarttab

Plug 'jiangmiao/auto-pairs'

" user interface
set laststatus=2
set ruler
set wildmenu
set tabpagemax=50
set cursorline
set number
set noerrorbells
set mouse=a
set title
set scrolloff=99

" search
set ignorecase
set smartcase


" save file
nnoremap zz :update<cr>
inoremap zz <esc>:update<cr>gi

" status line
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'

let g:lightline = {
      \ 'colorscheme': 'custom_lightline_theme',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'filetype' ] ],
		    \ 'right': [
		    \            ] },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name',    
	  \   'filename': 'LightlineFilename',
      \ },
      \ }

function! LightlineFilename()
  return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
        \ &filetype ==# 'unite' ? unite#get_status_string() :
        \ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
        \ expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

Plug 'frazrepo/vim-rainbow'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }



" ## TYPESCRIPT, JAVASCRIPT, REACT
" Pick one of these.
Plug 'HerringtonDarkholme/yats.vim'
Plug 'leafgarland/typescript-vim'

Plug 'peitalin/vim-jsx-typescript'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'pangloss/vim-javascript'

set updatetime=500
let g:typescript_indent_disable = 1

" For large JSX/TSX files, syntax highlighting can get out
" of sync. So we start/stop to mitigate that.
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" coc config
let g:coc_global_extensions = [ 'coc-tsserver',
\'coc-snippets',
\'coc-pairs',
\'coc-eslint',
\'coc-prettier',
\'coc-json'
\]

" typescript react
autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx
autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx

highlight cocfloating ctermbg=black

" show type documentation
nnoremap <silent> K :call CocAction('doHover')<CR>
" shows code actions
nmap <leader>do <Plug>(coc-codeaction)
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" go to definition 
nmap <silent> gd <Plug>(coc-definition)
" go to type definition
nmap <silent> gy <Plug>(coc-type-definition)
" go to implementation
nmap <silent> gi <Plug>(coc-implementation)
" list references for go-to access
nmap gr <plug>(coc-references)

" ### Diagnostics
" Show diagnostics window 
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
" previous diagnostic error
nmap <silent> U <Plug>(coc-diagnostic-prev)
" next diagnostic error
nmap <silent> I <Plug>(coc-diagnostic-next)

" tab completion
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <tab>
      \ pumvisible() ? "\<c-n>" :
      \ <sid>check_back_space() ? "\<tab>" :
      \ coc#refresh()

inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"

" ## NERDTREE
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

" Toggle NERDTree
function MyNerdToggle()
    if &filetype == 'nerdtree'
        :NERDTreeToggle
    else
        :NERDTreeFind
    endif
endfunction

nnoremap <C-l> :call MyNerdToggle()<CR>

let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" Show syntax group on CTRL+SHIFT+P when hovering with cursor.
nmap <Leader>sg :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" END PLUGS

call plug#end()

" go to file
nnoremap <C-o> :GFiles<CR>

" find text in project
nnoremap <C-F> :Rg<CR>

set termguicolors

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

set background=dark

source ~/.vim/colors/custom_color_scheme.vim

highlight colorcolumn ctermbg=0

let g:rainbow_active = 1

" make line numbers gray
:highlight linenr ctermfg=darkgrey

syntax on

" ## SOURCE OTHER FILES
source ~/Projects/dotfiles/vim/text_search.vim
source ~/Projects/dotfiles/vim/dim_active_window.vim
source ~/Projects/dotfiles/vim/markdown.vim
