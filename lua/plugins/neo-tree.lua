-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    },
    cmd = 'Neotree',
    lazy = false,
    init = function()
      vim.api.nvim_create_autocmd('BufEnter', {
        group = vim.api.nvim_create_augroup('NeoTreeInit', { clear = true }),
        callback = function()
          local f = vim.fn.expand '%:p'
          if vim.fn.isdirectory(f) ~= 0 then
            vim.cmd('Neotree current dir=' .. f)
            vim.api.nvim_clear_autocmds { group = 'NeoTreeInit' }
          end
        end,
      })
    end,
    keys = {
      { '<leader>tt', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
      { '<leader>tc', ':Neotree close<CR>', { desc = 'NeoTree close' } },
    },
    opts = {
      enable_diagnostics = false,
      filesystem = {
        hijack_netrw_behavior = 'open_current',
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        window = {
          mappings = {
            ['x'] = 'system_open',
            -- ['<leader>tt'] = 'close_current',
          },
        },
        commands = {
          system_open = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            -- macOs: open file in default application in the background.
            vim.fn.jobstart({ 'open', '-g', path }, { detach = true })
          end,
        },
      },
    },
  },
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neo-tree/neo-tree.nvim', -- makes sure that this loads after Neo-tree.
    },
    config = function()
      require('lsp-file-operations').setup()
    end,
  },
}
