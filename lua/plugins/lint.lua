return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      -- lint.linters_by_ft = {
      --   markdown = { 'markdownlint' },
      -- }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      lint.linters_by_ft = {
        -- javascript = { 'eslint_d' },
        -- typescript = { 'eslint_d' },
        -- javascriptreact = { 'eslint_d' },
        -- typescriptreact = { 'eslint_d' },
        vue = { 'eslint_d' },
        css = { 'stylelint' },
        scss = { 'stylelint' },
        less = { 'stylelint' },
        html = { 'htmlhint' },
        markdown = { 'vale' },
        text = { 'vale' },
        lua = { 'luacheck' },
        rust = { 'clippy' },
      }

      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      local config_path = vim.fn.stdpath 'config' .. '/linter-configs/'
      local parser = require 'lint.parser'

      lint.linters.eslint_d.args = { '--config', config_path .. 'eslint.config.mjs', '--format', 'json' }
      lint.linters.htmlhint.args = { '--config', config_path .. '.htmlhintrc' }
      lint.linters.luacheck.args = { '--config', config_path .. '.luacheckrc' }
      lint.linters.vale.args = { '--config', config_path .. '.vale.ini', '--output=JSON' }
      lint.linters.clippy.args = { '--message-format=json' }
      lint.linters.stylelint = {
        cmd = 'npx',
        stdin = true,
        append_fname = false,
        args = {
          'stylelint',
          '--config',
          config_path .. '.stylelintrc.json',
          '--stdin',
          '--stdin-filename',
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
        },
        parser = parser.from_errorformat('%f:%l:%c: %trror: %m,%f:%l:%c: %tarning: %m', {
          source = 'stylelint',
        }),
      }

      -- Vale error are now HINT
      local vale = lint.linters.vale
      local original_parser = vale.parser

      vale.parser = function(output, bufnr, linter_cwd)
        local diagnostics = original_parser(output, bufnr, linter_cwd)

        for _, diag in ipairs(diagnostics) do
          diag.severity = vim.diagnostic.severity.HINT
        end

        return diagnostics
      end

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
