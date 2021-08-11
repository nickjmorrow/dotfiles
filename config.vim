call plug#begin('~/.vim/plugged')
:set backspace=indent,eol,start
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'mileszs/ack.vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1
set wrap
" nerdtree file explorer, icons
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

" typescript, javascript, react
" Plug 'leafgarland/typescript-vim'
" Plug 'peitalin/vim-jsx-typescript'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'pangloss/vim-javascript'

set updatetime=500
let g:typescript_indent_disable = 1

" autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
" autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" show type documentation
nnoremap <silent> K :call CocAction('doHover')<CR>

nmap <leader>do <Plug>(coc-codeaction)

nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>

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

hi jsxTagName guifg=#E06C75
hi jsxComponentName guifg=#E06C75
hi jsxCloseComponentName guifg=#E06C75

" orange
hi jsxCloseString guifg=#F99575
hi jsxCloseTag guifg=#F99575
hi jsxCloseTagName guifg=#F99575
hi jsxAttributeBraces guifg=#F99575
hi jsxEqual guifg=#F99575

" yellow
hi jsxAttrib guifg=#F8BD7F cterm=italic

hi ReactState guifg=#C176A7
hi ReactProps guifg=#D19A66
hi ApolloGraphQL guifg=#CB886B
hi Events ctermfg=204 guifg=#56B6C2
hi ReduxKeywords ctermfg=204 guifg=#C678DD
hi ReduxHooksKeywords ctermfg=204 guifg=#C176A7
hi WebBrowser ctermfg=204 guifg=#56B6C2
hi ReactLifeCycleMethods ctermfg=204 guifg=#D19A66

" graphql
Plug 'jparise/vim-graphql'        

" styled components
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" colorschemes
Plug 'flazz/vim-colorschemes'
Plug 'jcherven/jummidark.vim'
Plug 'lifepillar/vim-solarized8'

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
set hlsearch
set ignorecase
set incsearch
set smartcase


" open file explorer
map <C-o> :NERDTreeToggle<CR>

let g:ackprg = 'ag --vimgrep --smart-case'
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack

highlight CocFloating ctermbg=black

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

" tab completion
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()


inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" go to file
nnoremap <C-p> :GFiles<CR>

set autochdir

" status line
Plug 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ }

Plug 'frazrepo/vim-rainbow'

set autoindent
set smartindent

" Dim inactive windows using 'colorcolumn' setting
" This tends to slow down redrawing, but is very useful.
" Based on https://groups.google.com/d/msg/vim_use/IJU-Vk-QLJE/xz4hjPjCRBUJ
" XXX: this will only work with lines containing text (i.e. not '~')
" from
if exists('+colorcolumn')
  function! s:DimInactiveWindows()
    for i in range(1, tabpagewinnr(tabpagenr(), '$'))
      let l:range = ""
      if i != winnr()
        if &wrap
         " HACK: when wrapping lines is enabled, we use the maximum number
         " of columns getting highlighted. This might get calculated by
         " looking for the longest visible line and using a multiple of
         " winwidth().
         let l:width=256 " max
        else
         let l:width=winwidth(i)
        endif
        let l:range = join(range(1, l:width), ',')
      endif
      call setwinvar(i, '&colorcolumn', l:range)
    endfor
  endfunction
  augroup DimInactiveWindows
    au!
    au WinEnter * call s:DimInactiveWindows()
    au WinEnter * set cursorline
    au WinLeave * set nocursorline
  augroup END
endif

call plug#end()

highlight ColorColumn ctermbg=0

let g:rainbow_active = 1

" make line numbers gray
:highlight LineNr ctermfg=darkgrey

syntax on

" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

if !has('gui_running')
  set t_Co=256
endif

set background=dark
