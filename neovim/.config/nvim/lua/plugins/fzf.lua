return {
  'ibhagwan/fzf-lua',
  event = 'VeryLazy',
  cmd = 'FzfLua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '<leader>ff', function() require('fzf-lua').files() end, desc = 'Find files' },
    { '<leader>fb', function() require('fzf-lua').buffers() end, desc = 'buffers' },
    { '<leader>fs', function() require('fzf-lua').live_grep() end, desc = 'live grep' },
    { '<leader>fo', function() require('fzf-lua').oldfiles() end, desc = 'live grep' },
  },
  config = function()
    local profile = vim.deepcopy(require('fzf-lua.profiles.telescope'))
    local prompt = ' 🔍' .. ' '

    -- override highlights
    profile.hls.preview_title = nil

    require('fzf-lua').setup({
      winopts = {
        preview = {
          wrap = 'wrap',
          scrollbar = false,
        },
      },
      keymap = {
        builtin = {
          ['<c-\\>'] = 'toggle-help',
          ['<c-f>'] = 'preview-page-down',
          ['<c-b>'] = 'preview-page-up',
        },
        fzf = {
          ['esc'] = 'abort',
          ['ctrl-q'] = 'select-all+accept',
          ['ctrl-f'] = 'preview-page-down',
          ['ctrl-b'] = 'preview-page-up',
          ['ctrl-u'] = 'half-page-up',
          ['ctrl-d'] = 'half-page-down',
        },
      },
      fzf_opts = {
        ['--no-scrollbar'] = true,
        ['--layout'] = 'default',
      },
      fzf_colors = profile.fzf_colors,
      hls = profile.hls,
      files = {
        prompt = prompt,
        cwd_prompt = false,
      },
      grep = {
        prompt = prompt,
        rg_opts = '--column --hidden --line-number --no-heading --color=never --smart-case --max-columns=4096 -e',
        rg_glob = true,
      },
      oldfiles = {
        prompt = prompt,
        cwd_only = true,
      },
      buffers = {
        prompt = prompt,
      },
      lsp = {
        symbols = {
          symbol_icons = require('lspkind').symbols,
        },
        finder = {
          prompt = prompt,
        },
      },
    })
  end,
}
