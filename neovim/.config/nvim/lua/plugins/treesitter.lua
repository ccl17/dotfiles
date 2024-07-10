return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    {
      'windwp/nvim-ts-autotag',
      config = true,
    },
    'RRethy/nvim-treesitter-endwise',
    {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      opts = {
        close_triple_quotes = true,
        check_ts = true,
        enable_moveright = true,
      },
    },
  },
  event = { 'BufReadPost', 'BufNewFile' },
  lazy = false,
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        'bash',
        'css',
        'dockerfile',
        'go',
        'hcl',
        'html',
        'javascript',
        'json',
        'lua',
        'make',
        'ruby',
        'scss',
        'terraform',
        'textproto',
        'vue',
        'yaml',
      },
      auto_install = true,
      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1501
      indent = {
        enable = true,
        disable = { 'ruby' },
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<cr>',
          scope_incremental = '<CR>',
          node_incremental = '<TAB>',
          node_decremental = '<S-TAB>',
        },
      },
      endwise = { enabled = true },
      autopair = { enable = true },
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['al'] = '@loop.outer',
            ['il'] = '@loop.inner',
            ['ib'] = '@block.inner',
            ['ab'] = '@block.outer',
            ['ir'] = '@parameter.inner',
            ['ar'] = '@parameter.outer',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_previous_start = {
            ['[f'] = { query = '@function.outer', desc = 'Previous function' },
            ['[c'] = { query = '@class.outer', desc = 'Previous class' },
            ['[p'] = { query = '@parameter.inner', desc = 'Previous parameter' },
          },
          goto_next_start = {
            [']f'] = { query = '@function.outer', desc = 'Next function' },
            [']c'] = { query = '@class.outer', desc = 'Next class' },
            [']p'] = { query = '@parameter.inner', desc = 'Next parameter' },
          },
        },
      },
    })
  end,
}
