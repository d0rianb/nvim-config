-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
vim.opt.relativenumber = true

-- Tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Set nowrap
vim.wo.wrap = false

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes:1'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 400

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

vim.opt.laststatus = 3

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    local opts = {
      focusable = false,
      close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(opts)
  end,
})

vim.diagnostic.config {
  virtual_text = false,
  underline = true,
  severity_sort = true,
  float = true,
}

-- Diagnostic keymaps
vim.keymap.set('n', 'gp', vim.diagnostic.goto_prev, { desc = 'Go to [P]revious diagnostic message' })
vim.keymap.set('n', 'gn', vim.diagnostic.goto_next, { desc = 'Go to [N]ext diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Adapt french keyboard to vim
vim.keymap.set('n', 'à', '0', { noremap = true, desc = 'Remap à to 0' })
vim.keymap.set('n', 'ù', '%', { noremap = true, desc = 'Remap ù to %' })
-- vim.keymap.set('n', 'œ', '<A-o>', { noremap = false, silent = true })
-- vim.keymap.set('n', 'Œ', '<A-O>', { noremap = false, silent = true })
-- vim.keymap.set('n', 'Ï', '<A-j>', { silent = true })
-- vim.keymap.set('n', 'È', '<A-k>', { silent = true })
vim.cmd [[
    map <silent>Ï <A-j>
    map <silent>È <A-k>
    map <silent> <C-k>
    map <silent>œ <A-o>
    map <silent>Œ <A-O>
]]

vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, desc = 'Remap jj to esc' })
vim.keymap.set('i', 'kk', '<Esc>', { noremap = true, desc = 'Remap kk esc' })

-- Disable the selection of the line ending character
vim.keymap.set('v', '$', 'g_', { noremap = true, silent = true })

-- Delete without perturbing the clipboard register
for _, key in ipairs { 'd', 'D', 'c', 'C' } do
  for _, mode in ipairs { 'n', 'v' } do
    vim.keymap.set(mode, key, '"_' .. key, { noremap = true })
    vim.keymap.set(mode, key .. key, '"_' .. key .. key, { noremap = true })
  end
end

-- Preserve clipboard when pasting over selection
vim.keymap.set('v', 'p', '"_dP', { noremap = true })

-- Preserve the selection when shifting
vim.keymap.set('x', '>', '>gv', { desc = 'Preserve the selection while shifting right' })
vim.keymap.set('x', '<', '<gv', { desc = 'Preserve the selection while shifting left' })

-- Alt-o to inster line before / after without leavinf normal mode
vim.keymap.set('n', '<A-o>', 'o<esc>', { desc = 'Inset line below' })
vim.keymap.set('n', '<A-O>', 'O<esc>', { desc = 'Inset line above' })

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<A-Left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<A-Right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<A-Down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<A-Up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Create panels
vim.keymap.set('n', '<C-k><Left>', '<C-w>v<C-w><Left>', { desc = 'Create a panel at the left' })
vim.keymap.set('n', '<C-k><Right>', '<C-w>v', { desc = 'Create a panel at the right' })
vim.keymap.set('n', '<C-k><Down>', '<C-w>s', { desc = 'Create a panel at the bottom' })
vim.keymap.set('n', '<C-k><Up>', '<C-w>s<C-w><Up>', { desc = 'Create a panel at the top' })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

require 'plugins'
require 'highlight' -- Should be the last to be declared

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
