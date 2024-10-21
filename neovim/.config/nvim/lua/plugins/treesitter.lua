return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    {
      'Wansmer/treesj',
      dependencies = 'nvim-treesitter',
      keys = {
        { '<leader>cj', '<cmd>TSJToggle<cr>', desc = 'Join/split code block' },
      },
      opts = { use_default_keymaps = false },
    },
  },
  build = ':TSUpdate',
  opts = {
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
      'scss',
      'terraform',
      'textproto',
      'vue',
      'yaml',
    },
    auto_install = true,
    indent = { enable = true },
    highlight = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['al'] = '@loop.outer',
          ['il'] = '@loop.inner',
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
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  },
  config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end,
}
