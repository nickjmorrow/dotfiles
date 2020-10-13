call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mg979/vim-visual-multi'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'luochen1990/rainbow'
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'jparise/vim-graphql'        " GraphQL syntax
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'ryanoasis/vim-devicons'
Plug 'flazz/vim-colorschemes'
Plug 'jcherven/jummidark.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'bluz71/vim-nightfly-guicolors'

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
set background=dark
set scrolloff=99

" search
set hlsearch
set ignorecase
set incsearch
set smartcase

" open file explorer
map <C-o> :NERDTreeToggle<CR>

" coc config
let g:coc_global_extensions = [ 'coc-tsserver',
\'coc-snippets',
\'coc-pairs',
\'coc-eslint',
\'coc-prettier',
\'coc-json'
\]

highlight CocFloating ctermbg=black

" typescript specific
set updatetime=500
let g:typescript_indent_disable = 1

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

nnoremap <silent> K :call CocAction('doHover')<CR>

nmap <leader>do <Plug>(coc-codeaction)

nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>

" typescript react
autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx
autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx

" save file
nnoremap zz :update<cr>
inoremap zz <Esc>:update<cr>gi

" remap rename current word
nmap <leader>rn <Plug>(coc-rename)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)

" go to file
nnoremap <C-p> :GFiles<CR>

" status line
Plug 'itchyny/lightline.vim'

" turn on line numbers
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

" make line numbers gray
:highlight LineNr ctermfg=grey

syntax on

" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

call plug#end()
set background=dark
colorscheme material 
set termguicolors

