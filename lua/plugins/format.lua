return { -- Autoformat
  'stevearc/conform.nvim',
  event = 'BufWritePre',
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
      local oxfmtrc = vim.fn.findfile('.oxmfmt.jsonc', '.;')
      if oxfmtrc ~= '' then
        local content = vim.fn.readfile(oxfmtrc)
        local text = table.concat(content, '\n')
        -- Check if empty or only whitespace/{}
        local is_disabled = text:match '^%s*$' or text:match '^%s*{}%s*$'
        if is_disabled then
          print 'Formating is disabled because of the empty .prettierrc'
          return nil -- Disable formatting
        end
      end

      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 1000,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'oxfmt' },
      typescript = { 'oxfmt' },
      javascriptreact = { 'oxfmt' },
      typescriptreact = { 'oxfmt' },
      html = { 'oxfmt' },
      css = { 'oxfmt' },
      json = { 'oxfmt' },
      yaml = { 'oxfmt' },
      markdown = { 'oxfmt' },
      python = {}, -- Ruff is initialized by nvim-lint
    },
    formatters = {
      oxfmt = {},
    },
  },
}
