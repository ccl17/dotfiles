return {
  'kylechui/nvim-surround',
  version = '*',
  event = 'VeryLazy',
  keys = {
    { 'Z', mode = 'v' },
    'ys',
    'yss',
    'yS',
    'cs',
    'ds',
  },
  opts = {
    move_cursor = true,
    keymaps = {
      visual = 'Z',
    },
  },
}
