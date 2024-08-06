-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
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
  },
  opts = {
    filesystem = {
      hijack_netrw_behavior = 'open_current',
      window = {
        mappings = {
          -- ['<leader>tt'] = 'close_current',
        },
      },
    },
  },
}
