return {
  'kylechui/nvim-surround',
  version = '*',
  keys = {
    { 's', mode = 'v' },
    'ys',
    'yss',
    'yS',
    'cs',
    'ds',
  },
  opts = { move_cursor = true, keymaps = { visual = 's' } },
}
