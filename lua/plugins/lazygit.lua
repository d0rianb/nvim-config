return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    lazygit = {
      configure = true,
      opts = {
        os = { editPreset = 'nvim-remote' },
        win = {
          style = 'lazygit',
        },
      },
    },
  },
  keys = {
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'LazyGit' },
  },
}
