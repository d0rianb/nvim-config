-- Enable 24-bit RGB color in the terminal UI
vim.opt.termguicolors = true

local diagnostic_colors = {
  Error = { fg = '#F44336', bg = '#51202A' },
  Warn = { fg = '#E5C07B', bg = '#4E4942' },
  Info = { fg = '#91949B', bg = '#373C4B' },
  Hint = { fg = '#7A7F87', bg = '#373C4B' },
}

-- Highlight groups for diagnostic signs and line numbers
for severity, colors in pairs(diagnostic_colors) do
  vim.api.nvim_set_hl(0, 'DiagnosticSign' .. severity, { fg = colors.fg, bg = colors.bg, bold = true })
  vim.api.nvim_set_hl(0, 'DiagnosticLineNr' .. severity, { fg = colors.fg, bg = colors.bg })
end

-- Underline style for diagnostics inside the buffer
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { sp = diagnostic_colors.Error.fg, undercurl = true })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { sp = diagnostic_colors.Warn.fg, undercurl = true })

-- Define signs with text, sign column highlight, and line number highlight
vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪',
      [vim.diagnostic.severity.INFO] = '󰋽',
      [vim.diagnostic.severity.HINT] = '󰌶',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticLineNrError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticLinWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticLineNrInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticLineNrHint',
    },
  },
}

-- Transparent background for floating windows
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
