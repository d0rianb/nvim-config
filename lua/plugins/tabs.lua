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
    { '<leader>tc', '<cmd>tabclose<cr>', desc = 'Close tab' },
    { '<tab>', '<cmd>tabnext<cr>', desc = 'Next tab' },
    { '<s-tab>', '<cmd>tabprev<cr>', desc = 'Prev tab' },
  },
}
