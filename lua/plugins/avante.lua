-- Like Roo code (VS Code) but for Nvim

return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false,
  opts = {
    provider = 'openai',
    providers = {
      openai = {
        api_key_name = 'AVANTE_OPENAI_API_KEY',
        endpoint = 'https://api.openai.com/v1',
        model = 'gpt-5',
      },
      vendors = {
        openrouter = {
          __inherited_from = 'openai',
          endpoint = 'https://openrouter.ai/api/v1',
          api_key_name = 'OPEN_ROUTER_KEY',
          -- api_key_name = os.getenv 'OPEN_ROUTER_KEY',
          model = 'anthropic/claude-3-haiku',
          timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
          temperature = 0,
          max_completion_tokens = 2000, -- Increase this to include reasoning tokens (for reasoning models)
          --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
          system_prompt = 'You are a senior developer assistant. Answer concisely and helpfully.',
        },
      },
    },
    context = {
      scope = 'project',
      include_hidden = false,
      max_tokens = 8000,
    },
    mappings = {
      -- submit = '<CR>',
    },
  },
  build = 'make BUILD_FROM_SOURCE=true',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
