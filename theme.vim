set background=dark
set syntax=on
colorscheme palenight

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

" Diagnostics
hi! DiagnosticSignError guibg=#51202A guifg=#F44336 gui=bold
hi! DiagnosticSignWarn guifg=#E5C07B guibg=#4E4942 
hi! DiagnosticSignInfo guifg=#91949B guibg=#373C4B
hi! DiagnosticSignHint guifg=#7A7F87 guibg=#373C4B
hi! DiagnosticUnderlineError guisp=#F44336 gui=undercurl term=undercurl cterm=undercurl 
hi! DiagnosticUnderlineWarn guisp=#E5C07B gui=undercurl term=undercurl cterm=undercurl 

" Matching parenthesis
hi! MatchParen gui=bold guibg=grey27 guifg=wheat

hi! CursorLine guibg=#2D3444
hi! link CursorColumn CursorLine 

" Popup
hi! Pmenu guibg=NONE
hi! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
hi! CmpItemAbbrMatch guibg=NONE guifg=#7C9AE0
hi! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#7C9AE0
hi! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
hi! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
hi! CmpItemKindText guibg=NONE guifg=#9CDCFE
hi! CmpItemKindFunction guibg=NONE guifg=#C586C0
hi! CmpItemKindMethod guibg=NONE guifg=#C586C0
hi! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
hi! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
hi! CmpItemKindUnit guibg=NONE guifg=#D4D4D4

" Nvim Tree
hi! NvimTreeCursorLine guibg=#3E4452
hi! NvimTreeOpenedFile guifg=#82B1FF
hi! NvimTreeWinSeparator guifg=#282d3d
hi! NvimTreeStatusLine guibg=#292e3e guifg=#292e3e
hi! NvimTreeStatusLineNC guibg=#292e3e guifg=#292e3e

" Git Gutter
hi! link GitGutterAddLineNr DiffAdd
hi! link GitGutterChangeLineNr DiffChange
hi! link GitGutterDeleteLineNr DiffDelete
hi! link GitGutterChangeDeleteLineNr DiffChangeDelete
