local function close_codediff_tab()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local filetype = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
    if filetype:match '^codediff' then
      vim.cmd.tabclose()
      return
    end
  end

  vim.notify('No CodeDiff tab to close', vim.log.levels.WARN)
end

return {
  'esmuellert/codediff.nvim',
  cmd = 'CodeDiff',
  opts = {
    diff = { layout = 'side-by-side' },
  },
  keys = {
    { '<leader>gd', '<cmd>CodeDiff<cr>', desc = 'Diff working tree' },
    { '<leader>gD', close_codediff_tab, desc = 'Close CodeDiff' },
  },
}
