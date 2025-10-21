-- LSP Configuration & Plugins

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      'hrsh7th/cmp-nvim-lsp',

      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = 'luvit-meta/library', words = { 'vim%.uv' } },
          },
        },
      },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Find references for the word under your cursor.
          map('gu', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>fr', require('telescope.builtin').lsp_document_symbols, '[F]ind [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<lead@er>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('gr', vim.lsp.buf.rename, '[R]ename')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          vim.keymap.set('n', 'ga', function()
            vim.lsp.buf.code_action {
              -- context = {
              --   only = {
              --     'quickfix',
              --     'refactor',
              --     'refactor.extract',
              --     'refactor.inline',
              --     'refactor.rewrite',
              --     'source', -- inclut fixAll, organizeImports, etc.
              --   },
              --   diagnostics = vim.diagnostic.get(),
              -- },
            }
          end, { desc = '[C]ode [A]ction' })
          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded' },
        underline = true,
        virtual_text = false,
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local vue_ls_share = vim.fn.expand '$MASON/packages/vue-language-server'
      local vue_language_server_path = vue_ls_share .. '/node_modules/@vue/language-server'

      local servers = {
        clangd = {},
        -- gopls = {},
        cssls = {},
        html = {},
        pyright = {},
        emmet_language_server = {
          filetypes = { 'html', 'css', 'less', 'sass', 'scss', 'vue' },
          init_options = {
            html = {},
          },
        },
        ts_ls = {
          on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
          capabilities = capabilities,
          filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
          init_options = {
            plugins = {
              {
                name = 'ts-lit-plugin',
                location = '/opt/homebrew/lib/node_modules/ts-lit-plugin',
              },
              {
                name = '@vue/typescript-plugin',
                location = vue_language_server_path,
                languages = { 'vue' },
              },
            },
          },
        },
        vue_ls = {
          on_init = function(client)
            client.handlers['tsserver/request'] = function(_, result, context)
              local ts_clients = vim.lsp.get_clients { bufnr = context.bufnr, name = 'ts_ls' }
              local clients = {}

              vim.list_extend(clients, ts_clients)

              if #clients == 0 then
                vim.notify('Could not find `vtsls` or `ts_ls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
                return
              end
              local ts_client = clients[1]

              local param = unpack(result)
              local id, command, payload = unpack(param)
              ts_client:exec_cmd({
                title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                command = 'typescript.tsserverRequest',
                arguments = {
                  command,
                  payload,
                },
              }, { bufnr = context.bufnr }, function(_, r)
                local response = r and r.body
                -- TODO: handle error or response nil here, e.g. logging
                -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
                local response_data = { { id, response } }

                ---@diagnostic disable-next-line: param-type-mismatch
                client:notify('tsserver/response', response_data)
              end)
            end
          end,
        },
        pylsp = {},
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = {
                disable = { 'missing-fields' },
                globals = { 'vim' },
              },
            },
          },
        },
        -- rust_analyzer = {
        --   -- on_attach = function(client, bufnr)
        --   --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        --   -- end,
        --   settings = {
        --     ['rust-analyzer'] = {
        --       cargo = {
        --         allFeatures = true,
        --       },
        --     },
        --   },
        -- },
      }

      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'eslint_d',
        'stylelint',
        'htmlhint',
        'vale',
        'luacheck',
      })

      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }
      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_enable = true,
      }

      for server_name, config in pairs(servers) do
        config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
        vim.lsp.config(server_name, config)
      end
    end,
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
  },
}
