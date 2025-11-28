-- Helper function for prettier args
local function generate_prettier_args(self, ctx)
  local config_files = {
    '.prettierrc',
    '.prettierrc.json',
    '.prettierrc.yml',
    '.prettierrc.yaml',
    '.prettierrc.json5',
    '.prettierrc.js',
    '.prettierrc.cjs',
    '.prettierrc.mjs',
    'prettier.config.js',
    'prettier.config.cjs',
    'prettier.config.mjs',
  }

  -- Check for local config
  local check_cwd = require('conform.util').root_file(config_files)
  local has_local_config = check_cwd(self, ctx) ~= nil

  -- Check for package.json with prettier config
  if not has_local_config then
    local package_json = vim.fn.findfile('package.json', '.;')
    if package_json ~= '' then
      local content = vim.fn.readfile(package_json)
      if vim.fn.match(content, '"prettier"') >= 0 then
        has_local_config = true
      end
    end
  end

  local base_args = { '--stdin-filepath', '$FILENAME' }

  if not has_local_config then
    local global_config = vim.fn.stdpath 'config' .. '/linter-configs/.prettierrc'
    return vim.list_extend(base_args, { '--config', global_config })
  end

  return base_args
end

return { -- Autoformat
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>=',
      function() require('conform').format { async = true, lsp_fallback = true } end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Check if .prettierrc exists and is empty or contains only {}
      local prettierrc = vim.fn.findfile('.prettierrc', '.;')
      if prettierrc ~= '' then
        local content = vim.fn.readfile(prettierrc)
        local text = table.concat(content, '\n')
        -- Check if empty or only whitespace/{}
        local is_disabled = text:match '^%s*$' or text:match '^%s*{}%s*$'
        if is_disabled then
          return nil -- Disable formatting
        end
      end

      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 1500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      python = {}, -- Ruff is initialized by nvim-lint
    },
    formatters = {
      prettier = {
        args = function(self, ctx) return generate_prettier_args(self, ctx) end,
      },
      prettierd = {
        args = function(self, ctx) return generate_prettier_args(self, ctx) end,
      },
    },
  },
}
