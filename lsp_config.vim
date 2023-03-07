sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticSignError
sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticSignWarn
sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticSignInfo
sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticSignHint

set shortmess+=c

lua << EOF

vim.lsp.set_log_level("debug")

vim.lsp.set_log_level("debug")

-- Show error in floating window
vim.diagnostic.config{ 
    virtual_text = false,
    underline = true,
    severity_sort = true
}

vim.api.nvim_create_autocmd('CursorHold', {
    buffer = bufnr,
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
    end
})

-- Mappings.
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', 'gp', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', 'gn', vim.diagnostic.goto_next, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gR', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>=', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  debounce_text_changes = 150,
}

local capabilities = require'cmp_nvim_lsp'.default_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig')['pylsp'].setup{
    on_attach = on_attach,
    capabilities = capabilities,
    flags = lsp_flags,
}

require('lspconfig')['tsserver'].setup{
    on_attach = on_attach,
    capabilities = capabilities,
    flags = lsp_flags,
}

require('lspconfig')['rust_analyzer'].setup{
    on_attach = on_attach,
    capabilities = capabilities,
    flags = lsp_flags,
    settings = {
      ["rust-analyzer"] = {}
    }
}

require('lspconfig')['lua_ls'].setup{
    on_attach = on_attach,
    capabilities = capabilities,
    flags = lsp_flags,
    settings = {
        Lua = { diagnostics = { globals = {'vim'} } }
    }
}

EOF
