local function close_tab()
  if vim.fn.tabpagenr('$') > 1 then
    vim.cmd.tabclose()
  else
    vim.notify('Cannot close the last tab page', vim.log.levels.WARN)
  end
end

return {
  'nanozuki/tabby.nvim',
  event = 'TabNew',
  config = function()
    require('tabby').setup {
      line = function(line)
        return {
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and 'TabLineSel' or 'TabLine'
            return {
              '  ',
              tab.number(),
              ' ',
              tab.name(),
              '  ',
              hl = hl,
            }
          end),
          hl = 'TabLineFill',
        }
      end,
    }
  end,
  keys = {
    { '<leader>tn', '<cmd>tabnew<cr>', desc = 'New tab' },
    { '<leader>tx', close_tab, desc = 'Close tab' },
    { ']t', '<cmd>tabnext<cr>', desc = 'Next tab' },
    { '[t', '<cmd>tabprev<cr>', desc = 'Prev tab' },
  },
}
