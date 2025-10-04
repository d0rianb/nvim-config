-- Linting Configuration
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    local config_path = vim.fn.stdpath 'config' .. '/linter-configs/'

    -- Find config file in project or fallback to global config
    local function find_config(filenames, fallback)
      local bufname = vim.api.nvim_buf_get_name(0)
      local root = vim.fs.dirname(bufname)

      for _, filename in ipairs(filenames) do
        local found = vim.fs.find(filename, {
          upward = true,
          path = root,
          type = 'file',
        })[1]

        if found then
          return vim.fs.normalize(found)
        end
      end

      return config_path .. fallback
    end

    -- Linters by filetype
    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
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

    -- ESLint_d: use daemon mode for faster linting
    vim.env.ESLINT_D_PPID = vim.fn.getpid()

    -- ESLint_d: find eslint.config.mjs, eslint.config.js, or .eslintrc.json
    local eslint_d = lint.linters.eslint_d
    eslint_d.args = function()
      local config = find_config({ 'eslint.config.mjs', 'eslint.config.js', '.eslintrc.json', '.eslintrc.js' }, 'eslint.config.mjs')
      return {
        '--config',
        config,
        '--format',
        'json',
        '--stdin',
        '--stdin-filename',
        vim.api.nvim_buf_get_name(0),
      }
    end

    -- Stylelint: find .stylelintrc.json or stylelint.config.js
    local stylelint = lint.linters.stylelint
    stylelint.args = function()
      local config = find_config({ '.stylelintrc.json', 'stylelint.config.js', '.stylelintrc' }, '.stylelintrc.json')
      return {
        '--config',
        config,
        '--formatter',
        'json',
        '--stdin-filename',
        vim.api.nvim_buf_get_name(0),
      }
    end

    -- HTMLHint: find .htmlhintrc
    local htmlhint = lint.linters.htmlhint
    htmlhint.args = function()
      local config = find_config({ '.htmlhintrc', '.htmlhintrc.json' }, '.htmlhintrc')
      return {
        '--config',
        config,
        '--format',
        'json',
      }
    end

    -- Luacheck: find .luacheckrc
    local luacheck = lint.linters.luacheck
    luacheck.args = function()
      local config = find_config({ '.luacheckrc' }, '.luacheckrc')
      return {
        '--config',
        config,
        '--formatter',
        'plain',
        '--codes',
        '--ranges',
        '--quiet',
        '-',
      }
    end

    -- Vale: find .vale.ini
    local vale = lint.linters.vale
    vale.args = function()
      local config = find_config({ '.vale.ini', '_vale.ini' }, '.vale.ini')
      return {
        '--config',
        config,
        '--output=JSON',
      }
    end

    -- Vale: convert errors to HINT severity
    local original_vale_parser = vale.parser
    vale.parser = function(output, bufnr, linter_cwd)
      local diagnostics = original_vale_parser(output, bufnr, linter_cwd)
      for _, diag in ipairs(diagnostics) do
        diag.severity = vim.diagnostic.severity.HINT
      end
      return diagnostics
    end

    -- Autocommand to trigger linting
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Manual lint command
    vim.api.nvim_create_user_command('Lint', function()
      lint.try_lint()
    end, { desc = 'Trigger linting for current file' })
  end,
}
