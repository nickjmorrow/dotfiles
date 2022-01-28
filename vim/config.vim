filetype plugin on

call plug#begin('~/.vim/plugged')

Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'


set wrap
set clipboard=unnamed

let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=1\x7"

let mapleader=","

set encoding=UTF-8

" indentation
set tabstop=4
set autoindent
set shiftround
set shiftwidth=4
set smarttab

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
" set hlsearch
" set ignorecase
" set incsearch
" set smartcase


" save file
nnoremap zz :update<cr>
inoremap zz <esc>:update<cr>gi

" status line
Plug 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ }

Plug 'frazrepo/vim-rainbow'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }


set autoindent
set smartindent

" ## TYPESCRIPT, JAVASCRIPT, REACT
" Pick one of these.
" Plug 'leafgarland/typescript-vim'
Plug 'HerringtonDarkholme/yats.vim'

Plug 'peitalin/vim-jsx-typescript'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'pangloss/vim-javascript'

" jsx tag colors
" dark red
hi tsxTagName guifg=#E06C75
hi tsxComponentName guifg=#E06C75
hi tsxCloseComponentName guifg=#E06C75

" orange
hi tsxCloseString guifg=#F99575
hi tsxCloseTag guifg=#F99575
hi tsxCloseTagName guifg=#F99575
hi tsxAttributeBraces guifg=#F99575
hi tsxEqual guifg=#F99575

" yellow
hi tsxAttrib guifg=#F8BD7F cterm=italic

" jsx generics
" light-grey
hi tsxTypeBraces guifg=#999999
" dark-grey
hi tsxTypes guifg=#666666

" other keywords
hi ReactState guifg=#C176A7
hi ReactProps guifg=#D19A66
hi ApolloGraphQL guifg=#CB886B
hi Events ctermfg=204 guifg=#56B6C2
hi ReduxKeywords ctermfg=204 guifg=#C678DD
hi ReduxHooksKeywords ctermfg=204 guifg=#C176A7
hi WebBrowser ctermfg=204 guifg=#56B6C2
hi ReactLifeCycleMethods ctermfg=204 guifg=#D19A66

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

" 
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
" remap rename current word
nmap <leader>rn <plug>(coc-rename)

" go to definition 
nmap <silent> gd <plug>(coc-definition)
" go to type definition
nmap <silent> gy <plug>(coc-type-definition)
" go to implementation
nmap <silent> gi <plug>(coc-implementation)
" list references for go-to access
nmap gr <plug>(coc-references)

nmap <silent> U <Plug>(coc-diagnostic-prev)
nmap <silent> I <Plug>(coc-diagnostic-next)

nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>

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

let g:ackorg = 'ag --vimgrep --smart-case'


cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack


call plug#end()

" go to file
nnoremap <C-p> :GFiles<CR>

colorscheme material

set background=dark
highlight colorcolumn ctermbg=0

let g:rainbow_active = 1

" make line numbers gray
:highlight linenr ctermfg=darkgrey

syntax on

" Nerdtree
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

nnoremap <C-l> :NERDTreeToggle<CR>

" Open NERDTree to current file
" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufRead * call SyncTree()
" END Open NERDTREE to current file


" set working directory to current file
set autochdir

set ignorecase

source ~/Projects/dotfiles/vim/text_search.vim
source ~/Projects/dotfiles/vim/dim_active_window.vim
source ~/Projects/dotfiles/vim/markdown.vim
