local cmp = require'cmp'
local lspkind = require'lspkind'
-- local cmp_window = require'cmp.utils.window'
local cmp_autopairs = require'nvim-autopairs.completion.cmp'

vim.o.completeopt = 'menu,menuone,noselect' 

lspkind.init() -- vscode-like pictograms in lsp

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<Tab>'] = cmp.mapping.confirm({ select = true }), 
    }),
    sources = {
        { name = 'vsnip' },
        { name = 'nvim_lua' },
        { name = 'nvim_lsp' },
        { name = 'buffer', keyword_length = 2 }
    },
    completion = {
        keyword_length = 1,
        completeopt = "menu,noselect"
    },
    view = { entries = 'custom' },
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = '[LSP]',
                vsnip = '[Snippet]',
                nvim_lua = '[Nvim Lua]',
                buffer = '[Buffer]',
            })[entry.source.name]
            vim_item.dup = ({
                vsnip = 0,
                nvim_lsp = 0,
                nvim_lua = 0,
                buffer = 0
            })[entry.source.name] or 0
            return vim_item
        end
    },
    enabled = function()
        -- disable completion in comments
        local context = require'cmp.config.context'
        local line = vim.api.nvim_get_current_line()
        local in_prompt = vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt'
        if in_prompt then  -- this will disable cmp in the Telescope window (taken from the default config)
            return false
        end
        if vim.api.nvim_get_mode().mode == 'c' then
            return true 
        else
            return not context.in_treesitter_capture("comment") 
                and not context.in_syntax_group("Comment")
        end
    end
})


