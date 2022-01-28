" dim inactive windows using 'colorcolumn' setting
" this tends to slow down redrawing, but is very useful.
" based on https://groups.google.com/d/msg/vim_use/iju-vk-qlje/xz4hjpjcrbuj
" xxx: this will only work with lines containing text (i.e. not '~')
" from
if exists('+colorcolumn')
  function! s:diminactivewindows()
    for i in range(1, tabpagewinnr(tabpagenr(), '$'))
      let l:range = ""
      if i != winnr()
        if &wrap
         " hack: when wrapping lines is enabled, we use the maximum number
         " of columns getting highlighted. this might get calculated by
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
  augroup diminactivewindows
    au!
    au winenter * call s:diminactivewindows()
    au winenter * set cursorline
    au winleave * set nocursorline
  augroup end
endif

