return {
  'folke/flash.nvim',
  keys = {
    {
      's',
      mode = { 'n', 'x', 'o' },
      function() require('flash').jump() end,
      desc = 'Flash',
    },
    {
      'S',
      mode = { 'n', 'x', 'o' },
      function() require('flash').treesitter() end,
      desc = 'Flash Treesitter',
    },
    {
      'r',
      mode = 'o',
      function() require('flash').remote() end,
      desc = 'Remote Flash',
    },
  },
  opts = {
    modes = {
      search = {
        enabled = false,
      },
    },
  },
}
