source ~/.config/nvim/plugins.vim
source ~/.config/nvim/theme.vim
source ~/.config/nvim/statusline.vim
source ~/.config/nvim/lsp_config.vim

lua require('cmp_config')

set clipboard=unnamed
set number
set relativenumber
set linebreak
set showbreak=>
set cursorline
set cursorlineopt=both
set signcolumn=yes:1
set textwidth=150
set showmatch
set visualbell
set nowrap
set hlsearch
set smartcase
set ignorecase
set incsearch
set ruler
set autoindent
set autochdir
set expandtab
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set backspace=indent,eol,start
set splitbelow
set splitright
set scrolloff=3
set shell=fish
set termguicolors
set mouse=a
set fillchars=eob:\ 

set backspace=indent,eol,start

let mapleader = " "

" for windows keymap
let g:skip_loading_mswin = 1

" Enable language specific config
filetype plugin indent on

" Use absolute line numbers in non-focused buffers
augroup numbertoggle
	autocmd!
  autocmd BufEnter,FocusGained * if index(['NvimTree', 'TelescopePrompt', 'toggleterm'], &ft) < 0 | setlocal relativenumber | endif
  autocmd BufLeave,FocusLost * setlocal norelativenumber
augroup END

augroup CursorLine
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

augroup NvimTree
  autocmd BufEnter,FocusGained * set norelativenumber
augroup END

" assumes set ignorecase smartcase
augroup dynamic_smartcase
    autocmd!
    autocmd CmdLineEnter : set nosmartcase
    autocmd CmdLineLeave : set smartcase
augroup END

" Clear selection on esc
map <silent><esc> :let @/ = "" <CR>

" Search for selection in visual mode via `//`
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

inoremap jj <Esc>

" adapt nvim to french keyboard
map à 0
map ù %
noremap <silent> <M-s> <cmd>w<cr> 

" to delete without perturbing the register
nnoremap d "_d
vnoremap d "_d
nnoremap c "_c
vnoremap c "_c
vnoremap p "_dP

noremap y "*y
noremap yy "*yy

map <C-d> <C-d>zz
map <C-u> <C-u>zz

xmap ' S'
" xmap " S" " Problem with clipboard selection
xmap ( S)
xmap { S}
xmap [ S]

" œ = <A-o>
map <silent>œ <A-o>
noremap <A-o> o<esc>
noremap <A-o> O<esc>

" Telescope mapping
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files( { cwd = vim.fn.expand('%:p:h') })<cr>
nnoremap <leader>fg <cmd>Telescope git_files hidden=true<cr>
nnoremap <leader>fc <cmd>Telescope commands<cr>
nnoremap <leader>fr <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>fb <cmd>Telescope file_browser hidden=true<cr>jj
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <leader>tt <cmd>NvimTreeToggle<cr>
nnoremap <leader>tf <cmd>NvimTreeFocus<cr>

" cabbrev ter <cmd>:let $VIM_DIR=expand('%:p:h')<cr>:terminal<cr>cd $VIM_DIR<cr>
nnoremap <A-t> <cmd>lua require("nvterm.terminal").new"horizontal"<cr>

" Vim multi-cursor
let g:VM_mouse_mappings = 1
nmap <A-LeftMouse> <Plug>(VM-Mouse-Cursor)

" Pane motion remap
func! ResizeV(dir) abort
    let l:dir = a:dir
    let l:amount = 4
    if winnr('l') == winnr()
        let l:dir = !l:dir
    endif
    execute 'vert resize' (l:dir ? '+' : '-') . l:amount 
endfunc

func! ResizeH(dir) abort
    let l:dir = a:dir
    let l:amount = 4
    if winnr('k') == winnr()
        let l:dir = !l:dir
    endif
    execute 'resize' (l:dir ? '+' : '-') . l:amount 
endfunc

map <silent>Ï <A-j>
map <silent>È <A-k>
map <A-Right> <C-w><Right>
map <A-Left> <C-w><Left>
map <A-Up> <C-w><Up>
map <A-Down> <C-w><Down>
map <S-Right> :<C-u>call ResizeV(1)<cr> 
map <S-Left> :<C-u>call ResizeV(0)<cr> 
map <S-Up> :<C-u>call ResizeH(1)<cr> 
map <S-Down> :<C-u>call ResizeH(0)<cr> 
map <C-k><Left> <C-w>v<C-w><Left> 
map <C-k><Right> <C-w>v 
map <C-k><Down> <C-w>s
map <C-k><Up> <C-w>s<C-w><Up>

" Move lines up and down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Emmet-vim -- test
let g:user_emmet_install_global = 0
autocmd FileType html,css,scss EmmetInstall

" vim-javascript
let g:javascript_plugin_jsdoc = 1

" Vim Gitgutter
let g:gitgutter_async = 1
let g:gitgutter_highlight_linenrs = 0
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▎'
let g:gitgutter_sign_modified_removed = '▎'

" Nvim Tree
command! TreeToggle NvimTreeToggle
command! TreeFocus NvimTreeFocus

" ToggleTerm
map <F5> <cmd>ToggleTerm<cr>

" Syntax highlighting for embeded lua
" let g:vimsyn_embed = 'l'

lua << EOF
local telescope = require'telescope'
telescope.setup{
    defaults = {
      mappings = {
            i = { ["<esc>"] = require'telescope.actions'.close },
      },
      vimgrep_arguments = {
         'rg',
         '--wfishe-filename',
         '--line-number',
         '--column',
         '--smart-case',
      },
      color_devicons = true,
      file_ignore_patterns = { 'node_modules', 'plugged', '.git', '.DS_Store', '__pycache__' },
      layout_config = {
         horizontal = {
            width = 0.8,
            height = 0.6,
            preview_width = 0.4,
          },
          vertical = {
            height = 0.5,
            preview_height = 0.5,
          },   
      },
      file_browser = { 
          hijack_netrw = true,
          mappings = {
            n = {
                ['r'] = telescope.extensions.file_browser.actions.rename,
                ['n'] = telescope.extensions.file_browser.actions.create,
                ['a'] = telescope.extensions.file_browser.actions.create,
                ['m'] = telescope.extensions.file_browser.actions.move,
            }
          }
      },
      extension = {
          ['ui-select'] = { require'telescope.themes'.get_dropdown{} }
      }
    }
}
telescope.load_extension'ui-select'
telescope.load_extension'file_browser'
telescope.load_extension'flutter'

require'neoscroll'.setup{}

require'nvim-autopairs'.setup{ enable_check_bracket_line = false }

require'nvim-tree'.setup{
    sync_root_with_cwd = true,
    prefer_startup_root = true,
    hijack_cursor = true,
    create_in_closed_folder = false,
    view = {
        signcolumn = 'no',
        number = false,
        adaptive_size = true,
        width = 20
    },
    filters = {
        dotfiles = true,
        exclude = { '.DS_Store', '^.git$', ':Zone.identifier$' }
    },
    actions = {
        open_file = { quit_on_open = false },
    },
    renderer = {
        highlight_git = false,
        highlight_opened_files = 'name',
        icons = { show = { git = false } },
         indent_markers = {
          enable = false,
          icons = {
            corner = '╰ ',
            edge = '│ ',
            item = '│ ',
            none = '  ',
        },
        },
    }
}

require'nvim-web-devicons'.setup {}

require'nvim-web-devicons'.get_icons()

require'nvim-treesitter.configs'.setup {
    ensure_installed = { 'javascript', 'typescript', 'scss', 'lua', 'rust', 'python', 'json', 'html' },
    sync_install = false,
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<A-v>',
            scope_incremental = '<cr>',
            node_incremental = '+',
            node_decremental = '-',
            },
        },
    indent = {
        enable = true,
        disable = { 'python' }
    },
    playground = {
        enable = true
    }
}

require'null-ls'.setup{}

require'dressing'.setup{
    input = { winblend = 0 }
}

require'Comment'.setup()

require'toggleterm'.setup{
    size = 12,
    persist_size = false,
    direction = 'horizontal',
    shade_terminals = false
}

require'flutter-tools'.setup{
    flutter_path = '/Users/dorian/Desktop/code/flutter/bin/',
    widget_guides = {
        enabled = false,
    },
    closing_tags = {
        highlight = "Comment", 
        prefix = "", 
        enabled = true 
    }
}
EOF
