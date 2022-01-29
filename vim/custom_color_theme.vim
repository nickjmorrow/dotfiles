hi clear
syntax reset
let g:colors_name = "custom_color_scheme"
set background=dark
set t_Co=256

function!  Coloring(group,guibg,guifg,gui,ctermbg,ctermfg)
  let highlightstr = 'highlight ' . a:group . ' '
  let highlightstr .= 'guibg=' . a:guibg . ' '
  let highlightstr .= 'guifg=' . a:guifg . ' '
  let highlightstr .= 'gui=' . a:gui . ' '
  let highlightstr .= 'ctermbg=' . a:ctermbg . ' '
  let highlightstr .= 'ctermfg=' . a:ctermfg . ' '
  let highlightstr .= 'cterm=' . a:gui . ' '

  execute highlightstr
endfunction

function! Col(group,guifg)
  let highlightstr = 'highlight ' . a:group . ' '
  let highlightstr .= 'guibg=' . 'NONE' . ' '
  let highlightstr .= 'guifg=' . a:guifg . ' '
  let highlightstr .= 'gui=' . 'NONE' . ' '
  let highlightstr .= 'ctermbg=' . 'NONE' . ' '
  let highlightstr .= 'ctermfg=' . 'NONE' . ' '
  let highlightstr .= 'cterm=' . 'NONE'. ' '
 
  execute highlightstr
endfunction

let CONSTANT="#bdcb17"
let WHITE="#FDF0ED"
let CYAN="#33ffeb"
let YELLOW="#ffc34d"
let MAGENTA="#ff337e"
let PURPLE="#965dff"
let BLUE="#6570ff"
let GREEN="#9afd7f"
let DARK_GRAY="#2E303E"
let ORANGE="#FF7F4D"
let TEAL="#8095A1"

hi Normal guifg=#e4dada ctermbg=NONE guibg=NONE gui=NONE
call Coloring("Normal", "NONE", WHITE, "NONE", "NONE", "NONE")
call Coloring("ColorColumn", DARK_GRAY, WHITE, "NONE", "NONE", "NONE")
call Col("typescriptExport",CYAN)
call Col("typescriptImport", CYAN)
call Col("typescriptCastKeyword", CYAN)
call Col("typescriptTypeBrackets", CYAN)
call Col("typescriptBraces", CYAN)
call Col("typescriptConditional", CYAN)
call Col("typescriptCase", CYAN)
call Col("typescriptDestructureVariable", WHITE)
call Col("typescriptDestructureLabel", WHITE)
call Col("typescriptObjectLabel", WHITE)
call Col("typescriptParens", CYAN)
call Col("typescriptArrowFunc", PURPLE)
call Col("typescriptAssign", PURPLE)
call Col("typescriptTypeReference", YELLOW)
call Col("typescriptMember", WHITE)
call Col("typescriptVariable", PURPLE)
call Col("typescriptVariableDeclaration", MAGENTA)
call Col("typescriptMemberOptionality", PURPLE)
call Col("typescriptCall", WHITE)
call Col("tsxTag", CYAN)
call Col("tsxTagName", YELLOW)
call Col("tsxCloseTag", CYAN)

call Col("tsxCloseComponentName", YELLOW)
call Col("tsxAttrib", PURPLE)
call Col("typescriptAliasDeclaration", YELLOW)
call Col("typescriptAliasKeyword", PURPLE)
call Col("typescriptInterfaceKeyword", PURPLE)
call Col("typescriptInterfaceName", YELLOW)
call Col("typescriptStringLiteralType", GREEN)
call Col("typescriptTypeQuery", PURPLE)
call Col("typescriptString", GREEN)
call Col("typescriptBoolean", GREEN)
call Col("typescriptNull", GREEN)
call Col("typescriptBOMHistoryProp", WHITE)
call Col("typescriptBinaryOp", PURPLE)
call Col("typescriptTernaryOp", PURPLE)
call Col("tsxAttributeBraces", CYAN)
call Col("tsxEqual", PURPLE)
call Col("typescriptBoolean", ORANGE)
call Col("typescriptNumber", ORANGE)
call Col("typescriptNull", ORANGE)
call Col("typescriptPredefinedType", TEAL)
call Col("typescriptEndColons", CYAN)
call Col("typescriptIdentifierName", BLUE)
call Col("typescriptDotNotation", CYAN)
call Col("typescriptClassKeyword", PURPLE)
call Col("typescriptClassName", YELLOW)
call Col("typescriptClassExtends", PURPLE)
call Col("typescriptGlobal", YELLOW)
call Col("typescriptTypeAnnotation", PURPLE)
call Col("jsFuncCall", BLUE)
call Col("jsFuncArgs", MAGENTA)
call Col("jsArrowFunction", PURPLE)
call Col("jsFuncBraces", CYAN)


call Coloring("CursorLine", "NONE", "NONE", "NONE", "NONE", "NONE")
call Coloring("CursorColumn", "NONE", "NONE", "NONE", "NONE", "NONE")

call Col("vimString", GREEN)
call Col("vimCommand", CYAN)
call Col("vimVar", MAGENTA)
call Col("vimHiGroup", MAGENTA)
call Col("vimGroup", MAGENTA)
call Col("vimHiGuiFgBg", MAGENTA)
call Col("vimOption", MAGENTA)

hi DiffText guifg=#fd1769 guibg=NONE

hi ErrorMsg guifg=#fd1769 guibg=NONE
hi WarningMsg guifg=#fd1769 guibg=NONE
hi PreProc guifg=#fd1769 guibg=NONE
hi Exception guifg=#fd1769 guibg=NONE
hi Error guifg=#fd1769 guibg=NONE
hi DiffDelete guifg=#fd1769 guibg=NONE
hi GitGutterDelete guifg=#fd1769 guibg=NONE
hi GitGutterChangeDelete guifg=#fd1769 guibg=NONE
hi cssIdentifier guifg=#fd1769 guibg=NONE
hi cssImportant guifg=#fd1769 guibg=NONE
hi Type guifg=#fd1769 guibg=NONE
hi Identifier guifg=#fd1769 guibg=NONE
hi PMenuSel guifg=#30ff6e guibg=NONE
hi Constant guifg=#30ff6e guibg=NONE
hi Repeat guifg=#30ff6e guibg=NONE
hi DiffAdd guifg=#30ff6e guibg=NONE
hi GitGutterAdd guifg=#30ff6e guibg=NONE
hi cssIncludeKeyword guifg=#30ff6e guibg=NONE
hi Keyword guifg=#30ff6e guibg=NONE
hi IncSearch guifg=#fdcb17 guibg=NONE
hi Title guifg=#fdcb17 guibg=NONE
hi PreCondit guifg=#fdcb17 guibg=NONE
hi Debug guifg=#fdcb17 guibg=NONE
hi SpecialChar guifg=#fdcb17 guibg=NONE
hi Conditional guifg=#fdcb17 guibg=NONE
hi Todo guifg=#fdcb17 guibg=NONE
hi Special guifg=#fdcb17 guibg=NONE
hi Label guifg=#fdcb17 guibg=NONE
hi Delimiter guifg=#fdcb17 guibg=NONE
hi Number guifg=#fdcb17 guibg=NONE
hi CursorLineNR guifg=#fdcb17 guibg=NONE
hi Define guifg=#fdcb17 guibg=NONE
hi MoreMsg guifg=#fdcb17 guibg=NONE
hi Tag guifg=#fdcb17 guibg=NONE
hi MatchParen guifg=#fdcb17 guibg=NONE
hi Macro guifg=#fdcb17 guibg=NONE
hi DiffChange guifg=#fdcb17 guibg=NONE
hi GitGutterChange guifg=#fdcb17 guibg=NONE
hi cssColor guifg=#fdcb17 guibg=NONE
hi Function guifg=#144bff guibg=NONE
hi Directory guifg=#8e3dff guibg=NONE
hi markdownLinkText guifg=#8e3dff guibg=NONE
hi Include guifg=#8e3dff guibg=NONE
hi Storage guifg=#8e3dff guibg=NONE
hi cssClassName guifg=#8e3dff guibg=NONE
hi cssClassNameDot guifg=#8e3dff guibg=NONE
hi Statement guifg=#00ffee guibg=NONE
hi Operator guifg=#00ffee guibg=NONE
hi cssAttr guifg=#00ffee guibg=NONE


hi Pmenu guifg=#e4dada guibg=#454545
hi SignColumn guibg=#16161c
hi Title guifg=#e4dada
hi LineNr guifg=#8c6666 guibg=#16161c
hi NonText guifg=#5c8863 guibg=#16161c
hi Comment guifg=#5c8863 gui=italic
hi SpecialComment guifg=#5c8863 gui=italic guibg=NONE
hi CursorLine guibg=#454545
hi TabLineFill gui=NONE guibg=#454545
hi TabLine guifg=#8c6666 guibg=#454545 gui=NONE
hi StatusLine gui=bold guibg=#454545 guifg=#e4dada
hi StatusLineNC gui=NONE guibg=#16161c guifg=#e4dada
hi Search guibg=#5c8863 guifg=#e4dada
hi VertSplit gui=NONE guifg=#454545 guibg=NONE
hi Visual gui=NONE guibg=#454545
