return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-telescope/telescope-file-browser.nvim', dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' } },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    local telescope = require 'telescope'
    telescope.setup {
      defaults = {
        mappings = {
          i = { ['<esc>'] = require('telescope.actions').close },
        },
        vimgrep_arguments = {
          'rg',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
        },
        color_devicons = true,
        file_ignore_patterns = { 'node_modules', 'plugged', '.git', '.DS_Store', '__pycache__', 'venv', 'dist', 'build' },
        layout_config = {
          horizontal = {
            width = 0.8,
            height = 0.6,
            preview_width = 0.4,
          },
          vertical = {
            height = 0.5,
            preview_height = 0.5,
          },
        },
        file_browser = {
          hijack_netrw = true,
          mappings = {
            n = {
              ['r'] = telescope.extensions.file_browser.actions.rename,
              ['n'] = telescope.extensions.file_browser.actions.create,
              ['a'] = telescope.extensions.file_browser.actions.create,
              ['m'] = telescope.extensions.file_browser.actions.move,
            },
          },
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'file_browser')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    local current_path = vim.fn.expand '%:p:h'
    local file_browser_callback = function()
      require('telescope').extensions.file_browser.file_browser { path = current_path }
    end
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>fb', file_browser_callback, { desc = '[F]ile [B]rowser' })
    vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>fc', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = 'Search Neovim [C]onfig files' })
  end,
}
