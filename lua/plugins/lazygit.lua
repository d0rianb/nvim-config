local function open_lazygit()
  vim.g.snacks_lazygit_win = vim.api.nvim_get_current_win()
  Snacks.lazygit()
end

local function restore_tint()
  local ok, tint = pcall(require, 'tint')
  local win = vim.g.snacks_lazygit_win
  if ok and type(win) == 'number' and vim.api.nvim_win_is_valid(win) then
    tint.untint(win)
  end
end

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    lazygit = {
      configure = true,
      config = {
        os = {
          editPreset = '',
          edit = 'nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}}',
          editAtLine = 'nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}} && nvim --server "$NVIM" --remote-send ":{{line}}<CR>"',
          editAtLineAndWait = 'nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}} && nvim --server "$NVIM" --remote-send ":{{line}}<CR>"',
        },
      },
    },
    styles = {
      lazygit = {
        backdrop = { transparent = true, blend = 85 },
        border = 'rounded',
        width = 0.9,
        height = 0.9,
        on_close = restore_tint,
        wo = {
          winblend = 0,
        },
      },
    },
  },
  keys = {
    { '<leader>gg', open_lazygit, desc = 'LazyGit' },
  },
}
