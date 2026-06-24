return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    lazygit = {
      configure = true,
      config = {
        os = { editPreset = 'nvim-remote' },
      },
    },
    styles = {
      lazygit = {
        backdrop = { transparent = true, blend = 85 },
        border = 'rounded',
        width = 0.9,
        height = 0.9,
        wo = {
          winblend = 0,
        },
      },
    },
  },
  keys = {
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'LazyGit' },
  },
}
