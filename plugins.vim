call plug#begin(expand('~/.config/nvim/plugged'))

" Color scheme
Plug 'drewtempelmeyer/palenight.vim'

Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'tpope/vim-surround', { 'branch': 'master' }
Plug 'kyazdani42/nvim-tree.lua'
Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'
Plug 'numToStr/Comment.nvim'
Plug 'akinsho/toggleterm.nvim', {'tag' : 'v2.*'}

" Telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim' " For telescope
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/playground'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim' " to use telescope ui for other purpose
Plug 'stevearc/dressing.nvim' " For ui select/input appearance

Plug 'declancm/cinnamon.nvim'
Plug 'alvan/vim-closetag'
Plug 'windwp/nvim-autopairs'


" Noice
Plug 'MunifTanjim/nui.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'folke/noice.nvim'

" Auto completion
Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'onsails/lspkind.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" Null-ls stuff
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'ThePrimeagen/refactoring.nvim'

Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'davidhalter/jedi-vim'
Plug 'akinsho/flutter-tools.nvim'
Plug 'python-rope/ropevim'

" Rust
Plug 'simrat39/rust-tools.nvim'
Plug 'togglebyte/togglerust'
Plug 'simrat39/rust-tools.nvim'
Plug 'rust-lang/rust.vim'

" Git
Plug 'airblade/vim-gitgutter'

Plug 'kyazdani42/nvim-web-devicons' " Should be the last one

call plug#end()
