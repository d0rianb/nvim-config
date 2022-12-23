sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticSignError
sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticSignWarn
sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticSignInfo
sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticSignHint

set shortmess+=c

let g:rustfmt_autosave = 1
let g:rustfmt_command = 'rustfmt --config-path ~/.config/rustfmt.toml'

lua << EOF
local lspconfig = require'lspconfig'

-- Show error in floating window
 vim.diagnostic.config{ 
     virtual_text = false,
     underline = true,
     severity_sort = true
}

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
   border = 'single',
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
   border = 'single',
   focusable = false,
   relative = 'cursor',
})

vim.o.updatetime = 250

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


-- Setup lspconfig.
local capabilities = require'cmp_nvim_lsp'.default_capabilities(vim.lsp.protocol.make_client_capabilities())
lspconfig['tsserver'].setup{ capabilities = capabilities }
lspconfig['rust_analyzer'].setup{ capabilities = capabilities }
-- lspconfig['pylsp'].setup{ capabilities = capabilities }

local buf_map = function(bufnr, mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
        silent = true,
    })
end

local on_attach = function(client, bufnr)
    vim.cmd('command! LspDef lua vim.lsp.buf.definition()')
    vim.cmd('command! LspFormatting lua vim.lsp.buf.formatting()')
    vim.cmd('command! LspCodeAction lua vim.lsp.buf.code_action()')
    vim.cmd('command! LspHover lua vim.lsp.buf.hover()')
    vim.cmd('command! LspRename lua vim.lsp.buf.rename()')
    vim.cmd('command! LspRefs lua vim.lsp.buf.references()')
    vim.cmd('command! LspTypeDef lua vim.lsp.buf.type_definition()')
    vim.cmd('command! LspImplementation lua vim.lsp.buf.implementation()')
    vim.cmd('command! LspDiagPrev lua vim.diagnostic.goto_prev()')
    vim.cmd('command! LspDiagNext lua vim.diagnostic.goto_next()')
    vim.cmd('command! LspDiagLine lua vim.diagnostic.open_float()')
    vim.cmd('command! LspSignatureHelp lua vim.lsp.buf.signature_help()')
    buf_map(bufnr, 'n', 'gd', ':LspDef<CR>')
    buf_map(bufnr, 'n', 'gi', ':LspImplementation<CR>')
    buf_map(bufnr, 'n', 'gr', ':LspRename<CR>')
    buf_map(bufnr, 'n', 'gt', ':LspTypeDef<CR>')
    buf_map(bufnr, 'n', 'K', ':LspHover<CR>')
    buf_map(bufnr, 'n', 'gp', ':LspDiagPrev<CR>')
    buf_map(bufnr, 'n', 'gn', ':LspDiagNext<CR>')
    buf_map(bufnr, 'n', 'ga', ':LspCodeAction<CR><Esc>')

    if client.server_capabilities.document_formatting then
        vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.format()')
    end
end

lspconfig.tsserver.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
        local ts_utils = require'nvim-lsp-ts-utils'
        ts_utils.setup({ always_organize_imports = false })
        ts_utils.setup_client(client)
        buf_map(bufnr, 'n', 'gs', ':TSLspOrganize<CR>')
        buf_map(bufnr, 'n', 'gR', ':TSLspRenameFile<CR>')
        buf_map(bufnr, 'n', 'go', ':TSLspImportAll<CR>')
        on_attach(client, bufnr)
    end
})

-- Rust
local opts = {
    tools = { 
        autoSetHints = true,
        -- hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = '',
            other_hints_prefix = '→ ',
        },
    },
    server = {
        settings = {
            standalone = true,
            ['rust-analyzer'] = {
                checkOnSave = { command = 'cargo check' },
                assist = {
                    importGranularity = 'module',
                },
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true
                },
                rustfmt = {
                    extraArgs = { '--config-path ~/.config/rustfmt.toml'}
                },
                procMacro = {
                    enable = true
                },
            }
        }
    },
}

require'rust-tools'.setup(opts)

-- Python
lspconfig.pylsp.setup{
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
    end,
    capabilities = capabilities
}


EOF
