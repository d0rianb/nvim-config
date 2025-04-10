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
  -- Use `opts = {}` to force a plugin to be loaded.
  --  This is equivalent to:
  --    require('Comment').setup({})

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
    config = function()
      vim.keymap.set({ 'n', 'v', 'i' }, '<A-Tab>', require('nvim-emmet').wrap_with_abbreviation)
    end,
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

  -- { -- Useful plugin to show you pending keybinds.
  --   'folke/which-key.nvim',
  --   event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  --   config = function() -- This is the function that runs, AFTER loading
  --     require('which-key').setup {
  --       window = {
  --         winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
  --       },
  --     }
  --
  --     -- Document existing key chains
  --     require('which-key').register {
  --       ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  --       ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  --       ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  --       ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  --       ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
  --       ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
  --       ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
  --     }
  --     -- visual mode
  --     require('which-key').register({
  --       ['<leader>h'] = { 'Git [H]unk' },
  --     }, { mode = 'v' })
  --   end,
  -- },

  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>=',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true, javascript = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
  },

  -- Highlight todo, notes, etc in comments
  -- { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

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
    "xzbdmw/colorful-menu.nvim",
    config = function()
        require("colorful-menu").setup({
            ls = {
                lua_ls = {
                    arguments_hl = "@comment",
                },
                gopls = {
                    align_type_to_right = true,
                    preserve_type_when_truncate = true,
                },
                ts_ls = {
                    -- false means do not include any extra info,
                    -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
                    extra_info_hl = "@comment",
                },
                ["rust-analyzer"] = {
                    -- Such as (as Iterator), (use std::io).
                    extra_info_hl = "@comment",
                    -- Similar to the same setting of gopls.
                    align_type_to_right = true,
                    -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
                    preserve_type_when_truncate = true,
                },
                clangd = {
                    -- Such as "From <stdio.h>".
                    extra_info_hl = "@comment",
                    -- Similar to the same setting of gopls.
                    align_type_to_right = true,
                    -- the hl group of leading dot of "•std::filesystem::permissions(..)"
                    import_dot_hl = "@comment",
                    -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
                    preserve_type_when_truncate = true,
                },
                -- If true, try to highlight "not supported" languages.
                fallback = true,
                fallback_extra_info_hl = "@comment",
            },
            fallback_highlight = "@variable",
        })
    end,
},
  -- {
  --   'ysmb-wtsg/in-and-out.nvim',
  --   keys = {
  --     {
  --       '<A-Tab>',
  --       function()
  --         require('in-and-out').in_and_out()
  --       end,
  --       mode = 'i',
  --     },
  --   },
  -- },
  require 'plugins/nvim-cmp',
  require 'plugins/telescope',
  require 'plugins/mini',
  require 'plugins/lsp',
  require 'plugins/treesitter',
  require 'plugins/neo-tree',
  require 'plugins/debug',
  require 'plugins/lint',
  require 'plugins/autopairs',
  require 'plugins/lazygit',
  require 'plugins/trouble',

  require 'colortheme',
}
