colorscheme material
" let g:material_theme_style = 'ocean'

" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

if !has('gui_running')
  set t_Co=256
endif

set background=dark

