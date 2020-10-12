call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mg979/vim-visual-multi'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'nickjmorrow/newdayone.vim'
Plug 'luochen1990/rainbow'
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'jparise/vim-graphql'        " GraphQL syntax
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

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

" search
set hlsearch
set ignorecase
set incsearch
set smartcase

" mappings
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

function! ShowDocIfNoDiagnostic(timer_id)
  if (coc#util#has_float() == 0)
    silent call CocActionAsync('doHover')
  endif
endfunction

function! s:show_hover_doc()
  call timer_start(500, 'ShowDocIfNoDiagnostic')
endfunction

autocmd CursorHoldI * :call <SID>show_hover_doc()
autocmd CursorHold * :call <SID>show_hover_doc()
nmap <leader>do <Plug>(coc-codeaction)
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
" typescript react
" set filetypes as typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx
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

" GoTo code navigation.
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
"
nnoremap <C-p> :GFiles<CR>
" status line
Plug 'itchyny/lightline.vim'

" turn on line numbers
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ }

" make line numbers gray
:highlight LineNr ctermfg=grey

syntax on

call plug#end()

