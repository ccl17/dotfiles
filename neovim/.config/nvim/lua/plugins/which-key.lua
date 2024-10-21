return {
  'folke/which-key.nvim',
  lazy = false,
  opts = {
    spec = {
      mode = { 'n', 'v' },
      { '<leader>b', group = 'buffers' },
      { '<leader>c', group = 'colors' },
      { '<leader>d', desc = 'debug' },
      { '<leader>D', group = 'database' },
      { '<leader>f', group = 'find/files' },
      { '<leader>g', group = 'gitfind/files' },
      { '<leader>s', group = 'search' },
      { '<leader>t', group = 'test' },
      { '<leader>u', group = 'toggle' },
      { '<leader>w', group = 'window' },
      { '<leader>x', group = 'quickfix' },
      { ']', group = 'next' },
      { '[', group = 'prev' },
    },
  },
  keys = {
    {
      '<leader>?',
      function() require('which-key').show() end,
      desc = 'which keys',
    },
  },
  config = function(_, opts) require('which-key').setup(opts) end,
}
