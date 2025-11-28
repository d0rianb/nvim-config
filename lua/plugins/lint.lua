-- Find config file in project or fallback to global config
local function find_config(filenames, fallback)
  local config_path = vim.fn.stdpath 'config' .. '/linter-configs/'
  local bufname = vim.api.nvim_buf_get_name(0)
  local root = vim.fs.dirname(bufname)

  for _, filename in ipairs(filenames) do
    local found = vim.fs.find(filename, { upward = true, path = root, type = 'file' })[1]

    if found then
      return vim.fs.normalize(found)
    end
  end

  return config_path .. fallback
end

-- Linting Configuration
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'

    -- Linters by filetype
    lint.linters_by_ft = {
      javascript = { 'oxlint' },
      typescript = { 'oxlint' },
      javascriptreact = { 'oxlint' },
      typescriptreact = { 'oxlint' },
      vue = { 'oxlint' },
      css = { 'stylelint' },
      scss = { 'stylelint' },
      less = { 'stylelint' },
      html = { 'htmlhint' },
      markdown = { 'vale' },
      text = { 'vale' },
      lua = { 'luacheck' },
      rust = { 'clippy' },
      python = { 'ruff' },
    }

    local oxlint = lint.linters.oxlint
    oxlint.args = {
      '--config',
      find_config({ 'oxlintrc.json', 'oxlintrc.jsonc' }, 'eslint.config.mjs'),
      '--format',
      'github',
      '--type-aware',
    }

    -- ESLint_d: use daemon mode for faster linting
    vim.env.ESLINT_D_PPID = vim.fn.getpid()

    -- ESLint_d: find eslint.config.mjs, eslint.config.js, or .eslintrc.json
    local eslint_d = lint.linters.eslint_d
    eslint_d.args = {
      '--config',
      find_config({ 'eslint.config.mjs', 'eslint.config.js', '.eslintrc.json', '.eslintrc.js' }, 'eslint.config.mjs'),
      '--format',
      'json',
      '--stdin',
      '--stdin-filename',
      vim.api.nvim_buf_get_name(0),
    }

    -- Stylelint: find .stylelintrc.json or stylelint.config.js
    local stylelint = lint.linters.stylelint
    stylelint.args = {
      '--config',
      find_config({ '.stylelintrc.json', 'stylelint.config.js', '.stylelintrc' }, '.stylelintrc.json'),
      '--formatter',
      'json',
      '--stdin-filename',
      vim.api.nvim_buf_get_name(0),
    }

    -- HTMLHint: find .htmlhintrc
    local htmlhint = lint.linters.htmlhint
    htmlhint.args = {
      '--config',
      find_config({ '.htmlhintrc', '.htmlhintrc.json' }, '.htmlhintrc'),
      '--format',
      'json',
    }

    -- Luacheck: find .luacheckrc
    local luacheck = lint.linters.luacheck
    luacheck.args = {
      '--config',
      find_config({ '.luacheckrc' }, '.luacheckrc'),
      '--formatter',
      'plain',
      '--codes',
      '--ranges',
      '--quiet',
      '-',
    }

    -- Vale: find .vale.ini
    local vale = lint.linters.vale
    vale.args = {
      '--config',
      find_config({ '.vale.ini', '_vale.ini' }, '.vale.ini'),
      '--output=JSON',
    }
    vale.ignore_exitcode = true
    -- Vale: convert errors to HINT severity
    local original_vale_parser = vale.parser
    vale.parser = function(output, bufnr, linter_cwd)
      local diagnostics = original_vale_parser(output, bufnr, linter_cwd)
      for _, diag in ipairs(diagnostics) do
        diag.severity = vim.diagnostic.severity.HINT
      end
      return diagnostics
    end

    local ruff = lint.linters.ruff
    ruff.args = {
      '--config',
      find_config({ 'pyproject.toml', 'ruff.toml', '.ruff.toml' }, 'ruff.toml'),
    }

    -- Autocommand to trigger linting
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
      group = lint_augroup,
      callback = function() lint.try_lint() end,
    })

    -- Manual lint command
    vim.api.nvim_create_user_command('Lint', function() lint.try_lint() end, { desc = 'Trigger linting for current file' })
  end,
}
