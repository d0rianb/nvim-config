local function open_nvim_tree(data)
  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not no_name and not directory then
    return
  end

  -- change to the directory
  if directory then
    vim.cmd.cd(data.file)
  end

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
      vim.cmd "quit"
    end
  end
})

require'nvim-tree'.setup{
    sync_root_with_cwd = true,
    prefer_startup_root = false,
    hijack_cursor = true,
    create_in_closed_folder = false,
    view = {
        signcolumn = 'no',
        number = false,
        adaptive_size = true,
        width = 20
    },
    filters = {
        dotfiles = true,
        exclude = { '.DS_Store', '^.git$', ':Zone.identifier$' }
    },
    actions = {
        open_file = { quit_on_open = false },
    },
    renderer = {
        highlight_git = false,
        highlight_opened_files = 'name',
        icons = { show = { git = false } },
         indent_markers = {
          enable = false,
          icons = {
            corner = '╰ ',
            edge = '│ ',
            item = '│ ',
            none = '  ',
        },
        },
    }
}
