lua << EOF

print('rust FTP')

vim.api.nvim_set_hl(0, '@keyword', { link = 'Repeat' })
vim.api.nvim_set_hl(0, '@field', { link = 'Tag' })
vim.api.nvim_set_hl(0, '@variable', { link = 'Tag' })
vim.api.nvim_set_hl(0, '@parameter', { link = 'Tag' })
vim.api.nvim_set_hl(0, '@variable.builtin', { link = 'Identifier' })

EOF
