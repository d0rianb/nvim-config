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

local function has_stylelint_config(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local root = vim.fs.dirname(bufname)
  local config_files = {
    'stylelint.config.js',
    'stylelint.config.mjs',
    'stylelint.config.cjs',
    'stylelint.config.ts',
    '.stylelintrc',
    '.stylelintrc.json',
    '.stylelintrc.js',
    '.stylelintrc.cjs',
  }

  return vim.fs.find(config_files, { upward = true, path = root, type = 'file' })[1] ~= nil
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
      markdown = { 'vale' },
      text = { 'vale' },
      lua = { 'luacheck' },
      python = { 'ruff' },
    }

    local oxlint = lint.linters.oxlint
    oxlint.args = {
      '--config',
      find_config({ 'oxlintrc.json', 'oxlintrc.jsonc', '.oxlintrc.json' }, '.oxlintrc.json'),
      '--format',
      'github',
      '--type-aware',
    }

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

    local ruff = lint.linters.ruff
    ruff.args = {
      'check',
      '--config',
      find_config({ 'pyproject.toml', 'ruff.toml', '.ruff.toml' }, 'ruff.toml'),
      '--output-format=json',
      '--stdin-filename',
      function() return vim.api.nvim_buf_get_name(0) end,
      '-',
    }

    local vale = lint.linters.vale
    vale.args = {
      '--config',
      find_config({ '.vale.ini', '_vale.ini' }, '.vale.ini'),
      '--output=JSON',
    }
    vale.ignore_exitcode = true
    local original_vale_parser = vale.parser
    vale.parser = function(output, bufnr, linter_cwd)
      local diagnostics = original_vale_parser(output, bufnr, linter_cwd)
      for _, diagnostic in ipairs(diagnostics) do
        diagnostic.severity = vim.diagnostic.severity.HINT
      end
      return diagnostics
    end

    -- Autocommand to trigger linting
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    local function try_lint()
      local bufnr = vim.api.nvim_get_current_buf()
      local stylelint_enabled = has_stylelint_config(bufnr)

      -- Oxfmt formats CSS; Stylelint only runs when a project opts in with config.
      if not stylelint_enabled then
        vim.diagnostic.reset(lint.get_namespace 'stylelint', bufnr)
      end

      lint.try_lint(nil, {
        filter = function(linter) return linter.name ~= 'stylelint' or stylelint_enabled end,
      })
    end

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
      group = lint_augroup,
      callback = try_lint,
    })

    -- Manual lint command
    vim.api.nvim_create_user_command('Lint', try_lint, { desc = 'Trigger linting for current file' })
  end,
}
