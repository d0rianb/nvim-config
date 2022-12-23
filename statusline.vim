" Get current mode
let g:currentmode={
      \'n' : 'Normal ',
      \'no' : 'N·Operator Pending ',
      \'v' : 'Visual ',
      \'V' : 'V·Line ',
      \'^V' : 'V·Block ',
      \'s' : 'Select ',
      \'S': 'S·Line ',
      \'^S' : 'S·Block ',
      \'i' : 'Insert ',
      \'R' : 'Replace ',
      \'Rv' : 'V·Replace ',
      \'c' : 'Command ',
      \'cv' : 'Vim Ex ',
      \'ce' : 'Ex ',
      \'r' : 'Prompt ',
      \'rm' : 'More ',
      \'r?' : 'Confirm ',
      \'!' : 'Shell ',
      \'t' : 'Terminal '
  \}

let g:modegroup={
      \'n' : 'StatusLineNormal',
      \'no' : 'StatusLineNormal',
      \'v' : 'StatusLineVisual',
      \'V' : 'StatusLineVisual',
      \'^V' : 'StatusLineVisual',
      \'s' : 'StatusLineVisual',
      \'S': 'StatusLineVisual',
      \'^S' : 'StatusLineVisual',
      \'i' : 'StatusLineInsert',
      \'R' : 'StatusLineReplace',
      \'Rv' : 'StatusLineReplace',
      \'c' : 'StatusLineCommand',
      \'cv' : 'StatusLineCommand',
      \'ce' : 'StatusLineCommand',
      \'r' : 'StatusLineWhite',
      \'rm' : 'StatusLineWhite',
      \'r?' : 'StatusLineWhite',
      \'!' : 'StatusLineWhite',
      \'t' : 'StatusLineWhite'
  \}

" Statusline colors
hi StatusLineBase     guifg=#212333 guibg=#1E272C
hi StatusLineGit      guifg=#929dcb guibg=#1E272C
hi StatusLineFiletype guifg=#929dcb guibg=#1E272C
hi StatusLineLineCol  guifg=#929dcb guibg=#1E272C
hi StatusLineModi                   guibg=#1E272C 
hi StatusLineFilename               guibg=#1E272C 


hi StatusLineNormal   gui=bold  guifg=#82aaff 
hi StatusLineInsert   gui=bold  guifg=#ffcb6b
hi StatusLineReplace  gui=bold  guifg=#ff5370
hi StatusLineVisual   gui=bold  guifg=#c3e88d
hi StatusLineCommand  gui=bold  guifg=#c792ea
hi StatusLineWhite    gui=bold  guifg=#eeffff

set noshowmode " No -- MODE -- display
" set cmdheight=0 " Maybe available in a future update

" Get current mode
function! ModeCurrent() abort
    let l:modecurrent = mode()
    let l:modelist = toupper(get(g:currentmode, l:modecurrent, 'Normal'))
    let l:current_status_color = get(g:modegroup, l:modecurrent, 'StatusLineNormal')
    let l:current_status_mode = l:modelist
    return "%#" .. l:current_status_color .. "#" .. l:current_status_mode
endfunction

" Get current git branch
function! GitBranch(git)
  if a:git == ""
    return '-'
  else
    return a:git
  endif
endfunction

" Get current filetype
function! CheckFT(filetype)
  if a:filetype == ''
    return '-'
  else
    return tolower(a:filetype)
  endif
endfunction

" Check modified status
function! CheckMod(modi)
  if a:modi == 1
    hi StatusLineModi guifg=#efefef 
    hi StatusLineFilename guifg=#efefef
    return expand('%:t').'*'
  else
    hi StatusLineModi guifg=#929dcb 
    hi StatusLineFilename guifg=#929dcb 
    return expand('%:t')
  endif
endfunction

" Set active statusline
function! ActiveLine()
  let statusline = "" " Set empty statusline and colors
  let statusline .= "%#StatusLineBase#"
  let statusline .= ModeCurrent() " Current mode
  " let statusline .= "%#StatusLineGit# %{GitBranch("")} %)" " Current git branch
  let statusline .= "%<%#StatusLineBase#"
  let statusline .= "%#StatusLineModi# %{CheckMod(&modified)} " " Current modified status and filename
  let statusline .= "%=" " Align items to right
  let statusline .= "%#StatusLineFiletype# %{CheckFT(&filetype)} "   " Current filetype
  let statusline .= "%#StatusLineLineCol# %l, %c " " Current line and column

  return statusline
endfunction

function! InactiveLine()
  let statusline = ""
  let statusline .= "%#StatusLineBase#"
  let statusline .= "%#StatusLineFilename# %F" " Full path of the file

  return statusline
endfunction

" Change statusline automatically
augroup Statusline
  autocmd!
  autocmd WinEnter,BufEnter * setlocal statusline=%!ActiveLine()
  autocmd WinLeave,BufLeave * setlocal statusline=%!InactiveLine()
augroup END
