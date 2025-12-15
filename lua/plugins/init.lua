-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  install = {
    colortheme = { 'palenight', 'tokyonight' },
  },
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'mg979/vim-visual-multi', -- mutli cursors
  { 'NMAC427/guess-indent.nvim', opts = {} },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '▎' },
        topdelete = { text = '▎' },
        changedelete = { text = '▎' },
      },
    },
  },
  {
    'olrtg/nvim-emmet',
    config = function() vim.keymap.set({ 'n', 'v', 'i' }, '<A-Tab>', require('nvim-emmet').wrap_with_abbreviation) end,
  },
  {
    'levouh/tint.nvim',
    config = function()
      require('tint').setup {
        tint = -20,
        saturation = 0.6,
      }
    end,
  },
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    'xzbdmw/colorful-menu.nvim',
    config = function()
      require('colorful-menu').setup {
        ls = {
          lua_ls = {
            arguments_hl = '@comment',
          },
          gopls = {
            align_type_to_right = true,
            preserve_type_when_truncate = true,
          },
          ts_ls = {
            -- false means do not include any extra info,
            -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
            extra_info_hl = '@comment',
          },
          ['rust-analyzer'] = {
            -- Such as (as Iterator), (use std::io).
            extra_info_hl = '@comment',
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
            -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
            preserve_type_when_truncate = true,
          },
          clangd = {
            -- Such as "From <stdio.h>".
            extra_info_hl = '@comment',
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
            -- the hl group of leading dot of "•std::filesystem::permissions(..)"
            import_dot_hl = '@comment',
            -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
            preserve_type_when_truncate = true,
          },
          -- If true, try to highlight "not supported" languages.
          fallback = true,
          fallback_extra_info_hl = '@comment',
        },
        fallback_highlight = '@variable',
      }
    end,
  },
  { 'ahmedkhalf/project.nvim' },
  { 'AckslD/swenv.nvim' }, -- for python venv choose
  {
    'Wansmer/treesj',
    lazy = true,
    keys = { '<space>m', '<space>j', '<space>s' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function() require('treesj').setup {} end,
  },
  {
    'stevearc/overseer.nvim',
    lazy = true,
    opts = {},
  },
  {
    'zchee/vim-flatbuffers',
    lazy = true,
    ft = { 'fbs' },
  },

  require 'plugins/autopairs',
  require 'plugins/blink-cmp',
  require 'plugins/telescope',
  require 'plugins/mini',
  require 'plugins/lsp',
  require 'plugins/treesitter',
  require 'plugins/gitsigns',
  require 'plugins/neo-tree',
  require 'plugins/debug',
  require 'plugins/lint',
  require 'plugins/format',
  require 'plugins/lazygit',
  require 'plugins/trouble',
  --
  require 'colortheme',
}
