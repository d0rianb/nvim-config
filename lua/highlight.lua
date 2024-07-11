-- Enables 24-bit RGB color in the TUI
vim.opt.termguicolors = true

-- Diagnostics
vim.api.nvim_set_hl(0, 'DiagnosticSignError', { bg = '#51202A', fg = '#F44336', bold = true })
vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { bg = '#4E4942', fg = '#E5C07B' })
vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { bg = '#373C4B', fg = '#91949B' })
vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { bg = '#373C4B', fg = '#7A7F87' })

vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { sp = '#F44336', undercurl = true })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { sp = '#E5C07B', undercurl = true })

vim.cmd [[
  sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticSignError
  sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticSignWarn
  sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticSignInfo
  sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticSignHint
]]

-- Float
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
