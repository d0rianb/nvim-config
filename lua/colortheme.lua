return {
  {
    'folke/tokyonight.nvim',
    lazy = true,
  },
  {
    'drewtempelmeyer/palenight.vim',
    lazy = false,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'palenight'
      -- vim.cmd [[ colorscheme palenight ]]
    end,
  },
}
